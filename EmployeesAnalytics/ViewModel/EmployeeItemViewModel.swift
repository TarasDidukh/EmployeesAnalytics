//
//  EmployeeItemViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift

public final class EmployeeItemViewModel : EmployeeItemViewModeling {
    var avatar =  MutableProperty<String?>(nil)
    var userName =  MutableProperty<String?>(nil)
    var position =  MutableProperty<String?>(nil)
    var employee: Employee?
    
    init(avatar: String?, userName: String?, position: String?, employee: Employee?) {
        self.avatar.value = avatar
        self.userName.value = userName
        self.position.value = position
        self.employee = employee
    }
}
