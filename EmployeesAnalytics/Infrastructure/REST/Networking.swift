//
//  Networking.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift
import Result

protocol Networking {
    var withApiToken: Bool { get set }
    func post<TRequest: Codable, TResponse: Codable, TError: ErrorProvider>(_ url: String, data: TRequest) -> SignalProducer<TResponse, TError>
    func post<TResponse: Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]?) -> SignalProducer<TResponse, TError>
    func post(_ url: String, parameters: [String: String]?) -> SignalProducer<(), NoError>
    
    func get<TResponse: Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]?) -> SignalProducer<TResponse, TError>
}

