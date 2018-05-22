//
//  MenuViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import ReactiveSwift
import Result


protocol MenuViewModeling {
    var Signout: Action<(), (), NoError>? { get set}
    var avatarUrl: MutableProperty<String?> { get }
    var userName: MutableProperty<String?> { get }
    var defaultError: MutableProperty<DefaultError?> { get }
    
    var employee: Employee? { get set }
}
