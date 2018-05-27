//
//  AuthenticationService.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift
import Result

public final class AuthenticationService : AuthenticationServicing {
    private var network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func signin(login: String, password: String) -> SignalProducer<(), SigninError> {
        let parameters : [String: String] = [
            "grant_type": "password",
            "username": login,
            "password": password
        ]
        let url = "\(Constants.BaseUrl)api/token"
        self.network.withApiToken = false
        let producer: SignalProducer<AuthInfo, SigninError> = self.network.post(url, parameters: parameters)
        return producer.on(value: { (authInfo) in
            UserDefaults.standard.set(authInfo.email, forKey: StorageKey.UserEmail.rawValue)
            UserDefaults.standard.set(authInfo.id, forKey: StorageKey.UserId.rawValue)
            UserDefaults.standard.set(authInfo.accessToken, forKey: StorageKey.ApiAccessToken.rawValue)
        }).map({ _ in return () })
    }
    
    func checkAuthentication() -> Bool {
        return UserDefaults.standard.string(forKey: StorageKey.ApiAccessToken.rawValue) != nil
    }
    
    func signout() {
        let url = "\(Constants.BaseUrl)api/account/Logout"
        let producer: SignalProducer<NoResult, DefaultError> = network.post(url, parameters: nil)
        producer.start()
        UserDefaults.standard.removeObject(forKey: StorageKey.ApiAccessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: StorageKey.UserEmail.rawValue)
        UserDefaults.standard.removeObject(forKey: StorageKey.UserId.rawValue)
        
    }
}
