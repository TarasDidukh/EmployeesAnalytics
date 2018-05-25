//
//  ProfileService.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public final class AccountService : AccountServicing {
    private var network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getProfile(withId id: String) -> SignalProducer<Employee?, DefaultError> {
        return SignalProducer { observer, disposable in
            if let object = UserDefaults.standard.value(forKey: id) as? NSData {
                let employee = NSKeyedUnarchiver.unarchiveObject(with: object as Data) as! Employee
                observer.send(value: employee)
            }
            
            let parameters : [String: String] = ["UserId": id]
            let url = "\(Constants.BaseUrl)api/users/GetUsersById"
            
            let producer: SignalProducer<EmployeeResult, DefaultError> = self.network.get(url, parameters: parameters)
            producer.on(
                failed: { (defaultError) in
                    observer.send(error: defaultError)
                    observer.sendCompleted()
            }, completed: {
                observer.sendCompleted()
            }, interrupted: {
                observer.sendCompleted()
            }, terminated: {
                observer.sendCompleted()
            }, value: { (employee) in
                if let employee = employee.data, employee.id == UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue) {
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: employee), forKey: employee.id!)
                }
                observer.send(value: employee.data)
                observer.sendCompleted()
            }).start()
        }
    }
    
    func searchEmployees(input: String?) -> SignalProducer<[Employee], DefaultError> {
        return SignalProducer { observer, disposable in
            let parameters : [String: String] = ["UserName": input ?? ""]
            let url = "\(Constants.BaseUrl)api/users/getUsersbyUserName"
            
            let producer: SignalProducer<[Employee], DefaultError> = self.network.get(url, parameters: parameters)
            producer.on(
                failed: { (defaultError) in
                    observer.send(error: defaultError)
                    observer.sendCompleted()
            }, completed: {
                observer.sendCompleted()
            }, interrupted: {
                observer.sendCompleted()
            }, terminated: {
                observer.sendCompleted()
            }, value: { (employees) in
                
                observer.send(value: employees)
                observer.sendCompleted()
            }).start()
        }
    }
    
    func getAllRoles() -> SignalProducer<[String], DefaultError> {
        return SignalProducer { observer, disposable in
            if let roles = UserDefaults.standard.value(forKey: StorageKey.AllRoles.rawValue) as? [String] {
                observer.send(value: roles)
                observer.sendCompleted()
                return;
            }
            
            let url = "\(Constants.BaseUrl)api/role/GetRoles"
            
            struct RolesResult: Codable {
                var data: [String]
                enum CodingKeys: String, CodingKey {
                    case data
                }
            }
            
            let producer: SignalProducer<RolesResult, DefaultError> = self.network.get(url, parameters: nil)
            producer.on(
                failed: { (defaultError) in
                    observer.send(error: defaultError)
                    observer.sendCompleted()
            }, completed: {
                observer.sendCompleted()
            }, interrupted: {
                observer.sendCompleted()
            }, terminated: {
                observer.sendCompleted()
            }, value: { (result) in
                if !result.data.isEmpty {
                    UserDefaults.standard.set(result.data, forKey: StorageKey.AllRoles.rawValue)
                }
                observer.send(value: result.data)
                observer.sendCompleted()
            }).start()
        }
    }
    
    func uploadAvatar(data: Data) -> SignalProducer<UploadedPhoto, DefaultError> {
        let url = "\(Constants.BaseUrl)api/v1/upload/upload/photo"
        return network.uploadImage(url, data: data)
    }
    
    func editProfile(employee: Employee) -> SignalProducer<Employee, DefaultError> {
        let url = "\(Constants.BaseUrl)api/users/editEmployeeProfile"
        return network.post(url, data: employee).on(value: { (result) in
            if result.id == UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue) {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: employee), forKey: employee.id!)
            }
        })
    }
}
