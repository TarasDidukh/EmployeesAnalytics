//
//  ExternalAppChannel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/23/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

public final class ExternalAppChannel : ExternalAppChanneling {
    func makeCall(_ number: String?) -> SignalProducer<(), NoError> {
        return SignalProducer { observer, disposable in
            guard let parameter = number, let number = URL(string: "tel://" + parameter) else {
                observer.sendCompleted()
                return
                
            }
            UIApplication.shared.open(number) { (result) in
                observer.sendCompleted()
            }
        }
    }
}
