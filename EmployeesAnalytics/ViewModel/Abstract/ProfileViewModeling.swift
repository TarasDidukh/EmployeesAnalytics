//
//  ProfileViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol ProfileViewModeling {
    var avatarUrl: MutableProperty<String?> { get }
    var userName: MutableProperty<String?> { get }
    var position: MutableProperty<String?> { get }
    var email: MutableProperty<String?> { get }
    var phone: MutableProperty<String?> { get }
    var skype: MutableProperty<String?> { get }
    var IsMyProfile: Bool { get }
    var employee: Employee? { get set }
}
