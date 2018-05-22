//
//  EmployeeItemViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

public final class EmployeeItemViewModel : EmployeeItemViewModeling {
    var avatar: String?
    var userName: String?
    var position: String?
    var employee: Employee?
    
    init(avatar: String?, userName: String?, position: String?, employee: Employee?) {
        self.avatar = avatar
        self.userName = userName
        self.position = position
        self.employee = employee
    }
}
