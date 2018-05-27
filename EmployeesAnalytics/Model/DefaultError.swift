//
//  NoError.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

public final class DefaultError : ErrorProvider {
    var type: NetworkError?
    var description: String = ""
    
    init() {
        type = NetworkError.Unknown
        
    }
    init(error: NSError) {
        type = NetworkError(error: error)
    }
    
    enum CodingKeys: String, CodingKey {
        case description
    }
    
}
