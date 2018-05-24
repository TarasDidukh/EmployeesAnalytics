//
//  PositionItemViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
public final class PositionItemViewModel : PositionItemViewModeling {
    var name: String
    var isSelected: MutableProperty<Bool>
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = MutableProperty<Bool>(isSelected)
    }
}
