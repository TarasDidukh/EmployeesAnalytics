//
//  ProfileViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public final class ProfileViewModel : ProfileViewModeling {
    var avatarUrl = MutableProperty<String?>(nil)
    var userName = MutableProperty<String?>(nil)
    var position = MutableProperty<String?>(nil)
    var email = MutableProperty<String?>(nil)
    var phone = MutableProperty<String?>(nil)
    var skype = MutableProperty<String?>(nil)
    var profileInfo = MutableProperty<[String]>([])
    var IsMyProfile = MutableProperty<Bool?>(nil)
    var Call: Action<(), (), NoError>?
    let externalAppChannel: ExternalAppChanneling
    var employee: Employee? {
        didSet {
            avatarUrl.value = employee?.avatarFull
            userName.value = employee?.userName
            position.value = employee?.position
            email.value = employee?.email
            phone.value = employee?.phoneNumber
            skype.value = employee?.skype
            IsMyProfile.value = employee?.isMyProfile
            var temp: [String] = []
            if !(email.value ?? "").isEmpty {
                temp.append(email.value!)
            }
            if !(phone.value ?? "").isEmpty {
                temp.append(phone.value!)
            }
            if !(skype.value ?? "").isEmpty {
                temp.append(skype.value!)
            }
            profileInfo.value = temp
        }
    }
    
    let accountService: AccountServicing
    
    func checkAvailableEdit() -> Bool {
        return accountService.checkAvailableEdit()
    }
    
    init(externalAppChannel: ExternalAppChanneling, accountService: AccountServicing) {
        self.accountService = accountService
        self.externalAppChannel = externalAppChannel
        
        Call = Action<(), (), NoError>(execute: { (index) in
            return externalAppChannel.makeCall(self.phone.value)
        })
    }
}
