//
//  EmployeesViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol EmployeesViewModeling {
    var Search: Action<(), [Employee], DefaultError>? { get set }
    var Call: Action<Int, (), NoError>? { get set }
    var searchInput: MutableProperty<String?> { get }
    var employeeItems: MutableProperty<[EmployeeItemViewModeling]> { get }
    var defaultError: MutableProperty<DefaultError?> { get }
    func edit(employee: Employee)
}
