//
//  PositionItemViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift
import Foundation

protocol PositionItemViewModeling {
    var name: String { get }
    var isSelected: MutableProperty<Bool> { get }
}
