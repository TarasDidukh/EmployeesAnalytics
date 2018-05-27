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
        if let object = UserDefaults.standard.value(forKey: id) as? NSData {
            let employee = NSKeyedUnarchiver.unarchiveObject(with: object as Data) as! Employee
            return SignalProducer { observer, disposable in
                observer.send(value: employee)
                observer.sendCompleted()
            }
        }
        
        let parameters : [String: String] = ["UserId": id]
        let url = "\(Constants.BaseUrl)api/users/GetUsersById"
        
        let producer: SignalProducer<EmployeeResult, DefaultError> = self.network.get(url, parameters: parameters)
        return producer.on(value: { (employee) in
            if let employee = employee.data, employee.isMyProfile {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: employee), forKey: employee.id)
                UserDefaults.standard.synchronize()
            }
        }).map({ $0.data })
    }
    
    func searchEmployees(input: String?) -> SignalProducer<[Employee], DefaultError> {
        let parameters : [String: String] = ["SearchName": input?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "",
                                             "PaginationViewObjectCount": String(100000)] //UserName
        let url = "\(Constants.BaseUrl)api/users/FilterUsers" // getUsersbyUserName
        
        struct FilterResult: Codable {
            var data: [Employee]
            enum CodingKeys: String, CodingKey {
                case data
            }
        }
        
        let producer: SignalProducer<FilterResult, DefaultError> = self.network.get(url, parameters: parameters)
        return producer.map({$0.data})
    }
    
    func getAllRoles() -> SignalProducer<[String], DefaultError> {
        if let roles = UserDefaults.standard.value(forKey: StorageKey.AllRoles.rawValue) as? [String] {
            return SignalProducer { observer, disposable in
                observer.send(value: roles)
                observer.sendCompleted()
            }
        }
        
        let url = "\(Constants.BaseUrl)api/role/GetRoles"
        
        struct RolesResult: Codable {
            var data: [String]
            enum CodingKeys: String, CodingKey {
                case data
            }
        }
        
        let producer: SignalProducer<RolesResult, DefaultError> = self.network.get(url, parameters: nil)
        return producer.on(value: { (result) in
            if !result.data.isEmpty {
                UserDefaults.standard.set(result.data, forKey: StorageKey.AllRoles.rawValue)
                UserDefaults.standard.synchronize()
            }
        }).map({ $0.data })
    }
    
    func uploadAvatar(data: Data) -> SignalProducer<UploadedPhoto, DefaultError> {
        let url = "\(Constants.BaseUrl)api/v1/upload/upload/photo"
        return network.uploadImage(url, data: data)
    }
    
    func checkAvailableEdit() -> Bool  {
        if let userId = UserDefaults.standard.value(forKey: StorageKey.UserId.rawValue) as? String, let object = UserDefaults.standard.value(forKey: userId) as? NSData {
            let employee = NSKeyedUnarchiver.unarchiveObject(with: object as Data) as! Employee
            let allowedEdit = ["Project manager", "CEO", "COO", "CMO", "CTO", "CFO", "HR"]
            return employee.roles?.contains(where: {allowedEdit.contains($0)}) ?? false
        }
        
        return false
    }
    
    func editProfile(employee: Employee) -> SignalProducer<Employee, DefaultError> {
        let url = "\(Constants.BaseUrl)api/users/editEmployeeProfile"
        return network.post(url, data: employee).on(value: { (result) in
            if result.isMyProfile {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: result), forKey: result.id)
                UserDefaults.standard.synchronize()
            }
        })
    }
}
