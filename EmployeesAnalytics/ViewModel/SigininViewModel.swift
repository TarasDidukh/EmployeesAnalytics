//
//  SigininViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

struct InputError: Error {
    let reason: String
}

public final class SigininViewModel : SigninViewModeling {
    var Signin: Action<(), (), SigninError>?
    
    var email: ValidatingProperty<String?, InputError> = ValidatingProperty<String?, InputError>(nil) {
        if $0 == nil || $0!.isEmpty {
            return .invalid(InputError(reason: NSLocalizedString("LoginEmpty", comment: "")))
        }
        
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: NSRegularExpression.Options.caseInsensitive)
        if regex.firstMatch(in: $0!, options: [], range: NSRange(location: 0, length: $0!.count)) == nil {
            return .invalid(InputError(reason: NSLocalizedString("LoginIncorrect", comment: "")))
        }
        return .valid
    }
    
    let signinError = MutableProperty<SigninError?>(nil)
    
    private var _signinError: SigninError?
    
    lazy var password: ValidatingProperty<String?, InputError> = ValidatingProperty<String?, InputError>(nil) {
        if self._signinError != nil && self._signinError?.type == NetworkError.InvalidGrant {
            return .invalid(InputError(reason: self._signinError?.type?.description ?? ""))
        } else {
            self.signinError.value = self._signinError
        }
        return $0 != nil && !$0!.isEmpty ? .valid : .invalid(InputError(reason: NSLocalizedString("PasswordEmpty", comment: "")))
    }
    
    let authenticationService: AuthenticationServicing
    
    init(authenticationService: AuthenticationServicing) {
        self.authenticationService = authenticationService
        let formValid = Property.combineLatest(email.result, password.result).map({
            !$0.isInvalid && !$1.isInvalid
        })
        
        Signin = Action<(), (), SigninError>(enabledIf: formValid, execute: { _ in
            return authenticationService.signin(login: self.email.value!, password: self.password.value!)
        })
        
        Signin?.errors.observe(on: UIScheduler()).observeValues({ (error) in
            self._signinError = error
            self.password.value = self.password.value
            self._signinError = nil
            self.signinError.value = nil
        })
    }
}
