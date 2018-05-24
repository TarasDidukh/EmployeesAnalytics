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
    var Call: Action<Int, (), NoError>?
    var searchInput = MutableProperty<String?>(nil)
    var employeeItems = MutableProperty<[EmployeeItemViewModeling]>([])
    var defaultError = MutableProperty<DefaultError?>(nil)
    
    let accountService: AccountServicing
    let externalAppChannel: ExternalAppChanneling
    
    var disposeSearch: Disposable?
    
    func convertToEmployeeItem(_ employee: Employee) -> EmployeeItemViewModeling {
        return EmployeeItemViewModel(avatar: employee.avatar, userName: employee.userName, position: employee.position, employee: employee)
    }
    
    init(accountService: AccountServicing, externalAppChannel: ExternalAppChanneling) {
        self.accountService = accountService
        self.externalAppChannel = externalAppChannel
        
        Search = Action<(), [Employee], DefaultError>(execute: { _ in
            return accountService.searchEmployees(input: self.searchInput.value)
        })
        Call = Action<Int, (), NoError>(execute: { (index) in
            return externalAppChannel.makeCall(self.employeeItems.value[index].employee?.phoneNumber)
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
