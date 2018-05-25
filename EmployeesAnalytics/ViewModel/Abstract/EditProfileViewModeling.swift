//
//  EditProfileViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/25/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
protocol EditProfileViewModeling {
    var Save: Action<(), (), DefaultError>? { get set}
    var employee: Employee? { get set }
    var avatar: MutableProperty<String?> { get }
    var name: ValidatingProperty<String?, InputError> { get }
    var lastName: ValidatingProperty<String?, InputError> { get }
    var positions: MutableProperty<[String]> { get }
    var email: ValidatingProperty<String?, InputError> { get }
    var phone: MutableProperty<String?> { get }
    var skype: MutableProperty<String?> { get }
}
