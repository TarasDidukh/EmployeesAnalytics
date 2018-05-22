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
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: employee), forKey: employee.id)
                }
                observer.send(value: employee.data)
                observer.sendCompleted()
            }).start()
        }
    }
}
