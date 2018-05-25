//
//  EmployeesView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Foundation
import Result
import SwipeCellKit

class EmployeesView: UITableViewController, SwipeTableViewCellDelegate {
    public var viewModel: EmployeesViewModeling?
    var searchBar = UISearchBar()
    var navigationData: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        tableView.tableFooterView = UIView()
        
        
        bindView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.employeeItems.producer
                .on(value: { _ in self.tableView.reloadData() })
                .start()
            viewModel.searchInput <~ searchBar.reactive.continuousTextValues
                .throttle(0.5, on: QueueScheduler.main)
            
            viewModel.Search?.isExecuting.producer.observe(on: UIScheduler()).on(value: { (isExecuting) in
                if viewModel.employeeItems.value.count == 0 {
                    if isExecuting {
                        self.view.activityIndicator(true, UIScreen.main.bounds.height/3)
                        self.view.emptyList(false)
                    } else {
                        self.view.activityIndicator(false)
                        self.view.emptyList(true, NSLocalizedString("EmptyEmployees", comment: ""), UIScreen.main.bounds.height/3 - 10)
                    }
                } else {
                    self.view.activityIndicator(false)
                    self.view.emptyList(false)
                }
            }).start()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.employeeItems.value.count
        }
        
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeItem", for: indexPath) as! EmployeeItem
        cell.viewModel = viewModel?.employeeItems.value[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.viewModel?.Call?.apply(indexPath.row).start(on: UIScheduler()).start()
        }
        
        deleteAction.image = UIImage(named: "telephone")
        deleteAction.backgroundColor = AppColors.ButtonBackground
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationData = viewModel?.employeeItems.value[indexPath.row].employee
        performSegue(withIdentifier: "showProfileViewEmployee", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileViewEmployee" {
            let nav = segue.destination as! UINavigationController
            let profileView: ProfileView = nav.topViewController as! ProfileView
            profileView.viewModel?.employee = navigationData
        }
    }
    
    func setupSearchBar() {
        //searchBar = UISearchBar(frame: CGRect(x: 200, y: 0, width: self.view.frame.width - 200, height: 44))
        
        searchBar.reactive.searchButtonClicked.observeValues { _ in
            self.viewModel?.searchInput.value = self.searchBar.text
            self.searchBar.endEditing(true)
        }
        navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                self.searchBar.text = ""
                self.viewModel?.searchInput.value = ""
                self.searchBar.endEditing(true)
                observer.sendCompleted()
            }
        }))
        
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let uiTextField = searchBar.subviews[0].subviews.last as? UITextField
        uiTextField?.layer.cornerRadius = 8
        uiTextField?.clipsToBounds = true
        uiTextField?.font = UIFont(name: "HelveticaNeue", size: 16)
        uiTextField?.layer.borderColor = AppColors.AlphaLight.cgColor
        let attributedString = NSMutableAttributedString(string: uiTextField!.placeholder!)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: AppColors.FieldPlaceholderColor, range: NSMakeRange(0, uiTextField!.placeholder!.count))
        uiTextField?.attributedPlaceholder = attributedString
        uiTextField?.layer.borderWidth = 1
        let searchIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchIcon.image = UIImage(named: "search")
        searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        searchIcon.tintColor = AppColors.SearchIconTint
        uiTextField?.rightView = nil
        uiTextField?.leftViewMode = UITextFieldViewMode.always
        uiTextField?.leftView = searchIcon
        navigationItem.titleView = searchBar
       
        searchBar.leftAnchor.constraint(equalTo: (navigationController?.navigationBar.leftAnchor)!, constant: 50).isActive = true
        searchBar.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -60).isActive = true
    }

}
