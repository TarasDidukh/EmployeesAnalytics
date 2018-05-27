//
//  EmployeeItemViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol EmployeeItemViewModeling {
    var avatar: MutableProperty<String?> { get set }
    var userName:  MutableProperty<String?> { get set }
    var position: MutableProperty<String?> { get set}
    var employee: Employee? { get set }
}
