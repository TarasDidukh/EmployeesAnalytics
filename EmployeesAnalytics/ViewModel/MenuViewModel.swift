//
//  MenuViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public final class MenuViewModel : MenuViewModeling {
    var Signout: Action<(), (), NoError>?
    
    let authenticationService: AuthenticationServicing
    let accountService: AccountServicing
    
    let avatarUrl = MutableProperty<String?>(nil)
    let userName = MutableProperty<String?>(nil)
    
    let defaultError = MutableProperty<DefaultError?>(nil)
    
    var employee: Employee?
    
    init(authenticationService: AuthenticationServicing, accountService: AccountServicing) {
        self.authenticationService = authenticationService
        self.accountService = accountService
        
        accountService.getProfile(withId: UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue)!)
            .observe(on: UIScheduler())
            .on(failed: { (defaulError) in
                self.defaultError.value = defaulError
            }, value: { (employee) in
                self.employee = employee
                if let employee = employee {
                   self.avatarUrl.value = employee.avatar
                    self.userName.value = employee.userName
                }
            }).start()
        
        Signout = Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                authenticationService.signout()
                observer.sendCompleted()
            }
        })
    }
}
