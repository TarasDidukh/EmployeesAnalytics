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
            
            if employee?.id == UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue) {
                IsMyProfile.value = true
            } else {
                IsMyProfile.value = false

            }
        }
    }
    
    init(externalAppChannel: ExternalAppChanneling) {
        self.externalAppChannel = externalAppChannel
        
        Call = Action<(), (), NoError>(execute: { (index) in
            return externalAppChannel.makeCall(self.phone.value)
        })
    }
}
