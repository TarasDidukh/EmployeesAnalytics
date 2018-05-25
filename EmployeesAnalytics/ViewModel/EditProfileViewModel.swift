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
    var Save: Action<(), Employee, DefaultError>?
    
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
    var phone = ValidatingProperty<String?, InputError>(nil) {
        $0 == nil || $0!.isEmpty ? .invalid(InputError(reason: NSLocalizedString("PhoneEmpty", comment: ""))) : .valid
    }
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
    
    var uploadedPhoto: UploadedPhoto?
    let accountService: AccountServicing
    var defaultError = MutableProperty<DefaultError?>(nil)
    
    var imageData: Data? {
        didSet {
            startUploadingAvatar()?.start()
        }
    }
    
    func startUploadingAvatar() -> SignalProducer<UploadedPhoto, DefaultError>? {
        if let data = imageData, !data.isEmpty {
            return accountService.uploadAvatar(data: data).observe(on: UIScheduler()).on(failed: { (error) in
                self.defaultError.value = error
            }) { (result) in
                self.uploadedPhoto = result
            }
        }
        return nil
    }
    
    func prepareEdit() {
        employee?.firstName = name.value
        employee?.lastName = lastName.value
        employee?.roles = positions.value
        employee?.phoneNumber = phone.value
        employee?.email = email.value
        employee?.skype = skype.value
        if let uploadedPhoto = uploadedPhoto {
            employee?.avatarURL = uploadedPhoto.pathFile
        }
    }
    
    init(accountService: AccountServicing) {
        self.accountService = accountService
        
        let formValid = Property.combineLatest(email.result, lastName.result, name.result, phone.result).map({ tuple in
            return !tuple.0.isInvalid && !tuple.1.isInvalid && !tuple.2.isInvalid && !tuple.3.isInvalid
        })
        
        Save = Action<(), Employee, DefaultError>(enabledIf: formValid, execute: { _ in
            if self.uploadedPhoto == nil, let uploadingPhoto = self.startUploadingAvatar() {
                return uploadingPhoto.on(value: { _ in
                    self.prepareEdit()
                }).flatMap(.latest, { _ in
                    self.accountService.editProfile(employee: self.employee!)
                })
            } else {
                self.prepareEdit()
                return accountService.editProfile(employee: self.employee!)
            }
        })
        
        Save?.errors.signal.observe(on: UIScheduler()).observeValues({ (defaultError) in
            self.defaultError.value = defaultError
        })
    }
    
}
