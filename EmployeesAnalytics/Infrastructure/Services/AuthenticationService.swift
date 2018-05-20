//
//  AuthenticationService.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift

public final class AuthenticationService : AuthenticationServicing {
    private var network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func signin(login: String, password: String) -> SignalProducer<(), SigninError> {
        return SignalProducer { observer, disposable in
            let parameters : [String: String] = [
                "grant_type": "password",
                "username": login,
                "password": password
            ]
            let url = "\(Constants.BaseUrl)api/token"
            self.network.withApiToken = false
            let producer: SignalProducer<AuthInfo, SigninError> = self.network.Post(url, parameters: parameters)
            producer.on(
                failed: { (signinError) in
                observer.send(error: signinError)
                observer.sendCompleted()
            }, completed: {
                observer.sendCompleted()
            }, interrupted: {
                observer.sendCompleted()
            }, terminated: {
                observer.sendCompleted()
            }, value: { (authInfo) in
                UserDefaults.standard.set(authInfo.email, forKey: StorageKey.UserEmail.rawValue)
                UserDefaults.standard.set(authInfo.id, forKey: StorageKey.UserId.rawValue)
                observer.sendCompleted()
            }).start()
            
        }
    }
    
    
}
