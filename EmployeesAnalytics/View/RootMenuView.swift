//
//  RootMenuView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import SideMenuController

class RootMenuView: SideMenuController {
    public var navigationData: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "showProfileView", sender: nil)
        performSegue(withIdentifier: "showMenuView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileView" {
            let nav = segue.destination as! UINavigationController
            let profileView: ProfileView = nav.topViewController as! ProfileView
            profileView.viewModel?.employee = navigationData as? Employee
        }
    }
    
}
