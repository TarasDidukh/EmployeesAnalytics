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

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "showEmployeesView", sender: nil)
        performSegue(withIdentifier: "showMenuView", sender: nil)
    }
}
