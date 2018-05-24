//
//  PickPositionsViewModeling.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift
import Foundation
protocol PickPositionsViewModeling {
    var positionItems: MutableProperty<[PositionItemViewModeling]> { get }
    var defaultError: MutableProperty<DefaultError?> { get }
    var selectedPositions: [String] { get set }
    func positionSelected(index: Int)
}
