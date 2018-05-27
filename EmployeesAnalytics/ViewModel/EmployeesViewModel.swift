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
        let convertertedEmployee = EmployeeItemViewModel(avatar: employee.avatar.isEmpty ? employee.avatarFull : employee.avatar, userName: employee.userName, position: employee.position, employee: employee)
        if !(searchInput.value ?? "").isEmpty, !(convertertedEmployee.userName.value ?? "").isEmpty {
            
            let startIndex = convertertedEmployee.userName.value?.lowercased().index(of: searchInput.value!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased())
            let endIndex = convertertedEmployee.userName.value?.lowercased().endIndex(of: searchInput.value!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased())
            if let startIndex = startIndex, let endIndex = endIndex {
                let stringToConvert = convertertedEmployee.userName.value![startIndex..<endIndex]
                convertertedEmployee.userName.value = convertertedEmployee.userName.value?.replacingOccurrences(of: stringToConvert, with: "<b>\(stringToConvert)</b>", options: String.CompareOptions.caseInsensitive)
            }
        }
        return convertertedEmployee
    }
    
    func edit(employee: Employee) {
        if var foundEmployee = employeeItems.value.first(where: { $0.employee?.id == employee.id }) {
            foundEmployee.employee = employee
            foundEmployee.avatar.value = employee.avatar.isEmpty ? employee.avatarFull : employee.avatar
            foundEmployee.position.value = employee.position
            foundEmployee.userName.value = employee.userName
        }
        
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
        
        Search?.errors.observe(on: UIScheduler()).observeValues({ (error) in
            self.defaultError.value = error
        })
        
        searchInput.producer.on { (input) in
            self.disposeSearch?.dispose()
            self.disposeSearch = self.Search?.apply().start()
        }.start()
    }
}
