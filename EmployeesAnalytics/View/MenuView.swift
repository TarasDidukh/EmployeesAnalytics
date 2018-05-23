//
//  MenuView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import Kingfisher

class MenuView: UITableViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    private let itemsMenu = [
        ("employee", NSLocalizedString("Employees", comment: ""), "showEmployeesView"),
        ("spedometer", NSLocalizedString("Dasboard", comment: ""), ""),
        ("project", NSLocalizedString("Projects", comment: ""), ""),
        ("projector", NSLocalizedString("WorkLogOwn", comment: ""), ""),
        ("vacation", NSLocalizedString("Vacation", comment: ""), ""),
        ("responsibilities", NSLocalizedString("Responsibilities", comment: ""), ""),
        ("logout", NSLocalizedString("LogOut", comment: ""), "showSigninView"),
    ]
    private var previousIndex: NSIndexPath?
    
    public var viewModel: MenuViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        
        profileImage.layer.cornerRadius = 37
        profileImage.layer.masksToBounds = true

        headerView.backgroundColor = AppColors.MenuHeaderBackgroundColor
        
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.tableView.bounces = false
        self.tableView.separatorColor = AppColors.MenuSeparatorColor
        self.tableView.tableFooterView = UIView()
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.defaultError.producer
                .on(value: { error in
                    if let errorMessage = error?.type?.description {
                        self.displayAlert(message: errorMessage)
                    }
                }).start()
            
            viewModel.avatarUrl.producer
                .on(value: { url in
                    if let url = url {
                        let processor = RoundCornerImageProcessor(cornerRadius: 37)
                        self.profileImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
                    }
                }).start()
            
            viewModel.userName.producer
                .on(value: { userName in
                    if let userName = userName {
                        self.userNameLabel.text = userName
                        if self.sideMenuController?.centerViewController is UINavigationController {
                            ((self.sideMenuController?.centerViewController as! UINavigationController).topViewController as? ProfileView)?.viewModel?.employee = viewModel.employee
                        }
                    }
                }).start()
        }
    }
    
    @IBAction func openProfile(_ sender: Any) {
        if let index = previousIndex {
            sideMenuController?.performSegue(withIdentifier: "showProfileView", sender: viewModel?.employee)
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        if sideMenuController?.sidePanelVisible == true {
            sideMenuController?.toggle()
        }
        previousIndex = nil
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsMenu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath) as! MenuItem

       cell.initItem(iconName: itemsMenu[indexPath.row].0, title: itemsMenu[indexPath.row].1)

        return cell
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if previousIndex?.row == indexPath.row {
            return
        }
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        if indexPath.row == 0 || indexPath.row == 6{
            sideMenuController?.performSegue(withIdentifier: itemsMenu[indexPath.row].2, sender: nil)
        }
        if let viewModel = viewModel, indexPath.row == 6 {
            viewModel.Signout?.apply().start()
            ImageCache.default.clearDiskCache()
        }
        previousIndex = indexPath as NSIndexPath?
        sideMenuController?.toggle()
    }

}
