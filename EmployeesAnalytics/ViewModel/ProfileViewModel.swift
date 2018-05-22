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
    var IsMyProfile = false
    var employee: Employee? {
        didSet {
            avatarUrl.value = employee?.avatar
            userName.value = employee?.userName
            position.value = employee?.position
            email.value = employee?.email
            phone.value = employee?.phoneNumber
            skype.value = employee?.skype
            
            if employee?.id == UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue) {
                IsMyProfile = true
            }
        }
    }
}
