//
//  AuthenticationServicing.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol AuthenticationServicing {
    func signin(login: String, password: String) -> SignalProducer<(), SigninError>
}
