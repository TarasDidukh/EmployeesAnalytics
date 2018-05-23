//
//  ExternalAppChanneling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/23/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

protocol ExternalAppChanneling {
    func makeCall(_ number: String?) -> SignalProducer<(), NoError>
}
