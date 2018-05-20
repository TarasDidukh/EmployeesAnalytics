//
//  Networking.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift

protocol Networking {
    var withApiToken: Bool { get set }
    func Post<TRequest: Codable, TResponse: Codable, TError: ErrorProvider>(_ url: String, _ data: TRequest) -> SignalProducer<TResponse, TError>
    func Post<TResponse: Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]) -> SignalProducer<TResponse, TError>
}

