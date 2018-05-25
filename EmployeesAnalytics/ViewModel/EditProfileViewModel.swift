//
//  EditProfileViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/25/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

public final class EditProfileViewModel : EditProfileViewModeling {
    var Save: Action<(), (), DefaultError>?
    
    var avatar = MutableProperty<String?>(nil)
    var name = ValidatingProperty<String?, InputError>(nil) {
        $0 == nil || $0!.isEmpty ? .invalid(InputError(reason: NSLocalizedString("NameEmpty", comment: ""))) : .valid
    }
    var lastName = ValidatingProperty<String?, InputError>(nil) {
        $0 == nil || $0!.isEmpty ? .invalid(InputError(reason: NSLocalizedString("LastNameEmpty", comment: ""))) : .valid
    }
    var positions = MutableProperty<[String]>([])
    var email = ValidatingProperty<String?, InputError>(nil){
        if $0 == nil || $0!.isEmpty {
            return .invalid(InputError(reason: NSLocalizedString("EmailEmpty", comment: "")))
        }
        
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: NSRegularExpression.Options.caseInsensitive)
        if regex.firstMatch(in: $0!, options: [], range: NSRange(location: 0, length: $0!.count)) == nil {
            return .invalid(InputError(reason: NSLocalizedString("LoginIncorrect", comment: "")))
        }
        return .valid
    }
    var phone = MutableProperty<String?>(nil)
    var skype = MutableProperty<String?>(nil)
    
    var employee: Employee? {
        didSet {
            if let employee = employee {
                avatar.value = employee.avatarFull
                name.value = employee.firstName
                lastName.value = employee.lastName
                positions.value = employee.roles ?? []
                email.value = employee.email
                phone.value = employee.phoneNumber
                skype.value = employee.skype
            }
        }
    }
    
    init(accountService: AccountServicing) {
        
    }
    
}
