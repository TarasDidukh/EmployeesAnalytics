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

class EmployeesView: UITableViewController {
    public var viewModel: EmployeesViewModeling?
    let searchBar = UISearchBar()
    var navigationData: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        tableView.tableFooterView = UIView()
        
        bindView()
        
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.employeeItems.producer
                .on(value: { _ in self.tableView.reloadData() })
                .start()
            viewModel.searchInput <~ searchBar.reactive.continuousTextValues
                .throttle(0.5, on: QueueScheduler.main)
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
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationData = viewModel?.employeeItems.value[indexPath.row].employee
        performSegue(withIdentifier: "showProfileViewEmployee", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileViewEmployee" {
            let nav = segue.destination as! UINavigationController
            let profileView: ProfileView = nav.topViewController as! ProfileView
            profileView.viewModel?.employee = navigationData
        }
    }
    
    func setupSearchBar() {
        
        
        searchBar.reactive.searchButtonClicked.observeValues { _ in
            self.viewModel?.searchInput.value = self.searchBar.text
            self.searchBar.endEditing(true)
        }
        searchBar.reactive.cancelButtonClicked.observeValues { _ in
            self.viewModel?.searchInput.value = ""
            self.searchBar.endEditing(true)
        }
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let uiTextField = searchBar.value(forKey: "searchField") as? UITextField
        uiTextField?.layer.cornerRadius = 8
        uiTextField?.clipsToBounds = true
        uiTextField?.font = UIFont(name: "HelveticaNeue", size: 16)
        uiTextField?.layer.borderColor = AppColors.AlphaLight.cgColor
        let attributedString = NSMutableAttributedString(string: uiTextField!.placeholder!)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: AppColors.FieldPlaceholderColor, range: NSMakeRange(0, uiTextField!.placeholder!.count))
        uiTextField?.attributedPlaceholder = attributedString
        uiTextField?.layer.borderWidth = 1
        let searchIcon = uiTextField?.leftView as! UIImageView;
        searchIcon.image = UIImage(named: "searchSB")
        searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        searchIcon.tintColor = AppColors.SearchIconTint;
        uiTextField?.leftView = searchIcon;
        navigationItem.titleView = searchBar;
    }

}
