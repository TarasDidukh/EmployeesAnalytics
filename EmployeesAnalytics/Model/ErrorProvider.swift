//
//  ErrorProvider.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

protocol ErrorProvider : Error, Codable{
    var type: NetworkError? { get }
    var description: String? { get }
    
    init(error: NSError)
    init()
}
