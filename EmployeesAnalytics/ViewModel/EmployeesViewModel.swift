//
//  EmployeesViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public final class EmployeesViewModel : EmployeesViewModeling {
    var Search: Action<(), [Employee], DefaultError>?
    var searchInput = MutableProperty<String?>(nil)
    var employeeItems = MutableProperty<[EmployeeItemViewModeling]>([])
    var defaultError = MutableProperty<DefaultError?>(nil)
    
    let accountService: AccountServicing
    
    var disposeSearch: Disposable?
    
    func convertToEmployeeItem(_ employee: Employee) -> EmployeeItemViewModeling {
        return EmployeeItemViewModel(avatar: employee.avatar, userName: employee.userName, position: employee.position, employee: employee) as EmployeeItemViewModeling
    }
    
    init(accountService: AccountServicing) {
        self.accountService = accountService
        
        Search = Action<(), [Employee], DefaultError>(execute: { _ in
            return accountService.searchEmployees(input: self.searchInput.value)
        })
        
        Search?.values.observe(on: UIScheduler()).observeResult({ (result) in
            if let result = result.value {
                self.employeeItems.value = result.map({ self.convertToEmployeeItem($0) })
            } else {
                self.employeeItems.value = []
            }
        })
        
        searchInput.producer.on { (input) in
            self.disposeSearch?.dispose()
            self.disposeSearch = self.Search?.apply().start()
        }.start()
    }
}
