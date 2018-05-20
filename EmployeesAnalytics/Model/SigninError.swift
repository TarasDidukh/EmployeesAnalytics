//
//  SigninError.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

public final class SigninError : ErrorProvider{
    var type: NetworkError?
    var error: String?
    var description: String?
    
    init(error: NSError) {
        type = NetworkError(error: error)
    }
    
    init() {
        type = NetworkError.Unknown
    }
    
   public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decode(String?.self, forKey: .error)
        description = try values.decode(String?.self, forKey: .description)
    
        if error == "invalid_grant"{
            type = NetworkError.InvalidGrant
        } else {
            type = NetworkError.Unknown
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}
