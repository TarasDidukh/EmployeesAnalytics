//
//  ProfileServicing.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import Foundation
import ReactiveSwift
import Result


protocol AccountServicing {
    func getProfile(withId id: String) -> SignalProducer<Employee?, DefaultError>
    
    func searchEmployees(input: String?) -> SignalProducer<[Employee], DefaultError>
    
     func getAllRoles() -> SignalProducer<[String], DefaultError>
}
