//
//  EmployeeItemViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

protocol EmployeeItemViewModeling {
    var avatar: String? { get }
    var userName: String? { get }
    var position: String? { get }
    var employee: Employee? { get }
}
