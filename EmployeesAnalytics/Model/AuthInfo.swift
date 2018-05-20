//
//  AuthInfo.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//


struct AuthInfo: Codable {
    let accessToken, tokenType: String
    let userName, id, roles, email: String
    let issued, expires: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case userName, id, roles, email
        case issued = ".issued"
        case expires = ".expires"
    }
}
