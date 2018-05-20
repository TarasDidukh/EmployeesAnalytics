//
//  SigninViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import ReactiveSwift
import Result


protocol SigninViewModeling {
    var Signin: Action<(), (), SigninError>? { get set}
    var email: ValidatingProperty<String?, InputError> { get set}
    var password: ValidatingProperty<String?, InputError> { get set}
    var signinError: MutableProperty<SigninError?> { get }
}
