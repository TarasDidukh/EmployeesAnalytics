//
//  MenuItem.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import UIKit

public class MenuItem: UITableViewCell {
    @IBOutlet weak var iconMenu: UIImageView!
    @IBOutlet weak var titleMenu: UILabel!
    
    func initItem(iconName: String, title: String) {
        iconMenu.image = UIImage(named: iconName)
        iconMenu.tintColor = AppColors.MenuItemIconTint
        titleMenu.text = title
    }
}
