//
//  PickPositionViewModel.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public final class PickPositionsViewModel : PickPositionsViewModeling {
    var positionItems = MutableProperty<[PositionItemViewModeling]>([])
    var defaultError = MutableProperty<DefaultError?>(nil)
    var selectedPositions: [String] = [] {
        didSet {
            accountService.getAllRoles().observe(on: UIScheduler()).on(failed: { (defaulError) in
                self.defaultError.value = defaulError
            }, value: { (roles) in
                self.positionItems.value = roles.map({ self.convertToPositionItem($0) })
            }).start()
        }
    }
    func positionSelected(index: Int) {
        positionItems.value[index].isSelected.value = !positionItems.value[index].isSelected.value
        if positionItems.value[index].isSelected.value {
            selectedPositions.append(positionItems.value[index].name)
        } else if let index = selectedPositions.index(of: positionItems.value[index].name) {
            selectedPositions.remove(at: index)
        }
    }
    
    func convertToPositionItem(_ name: String) -> PositionItemViewModeling {
        return PositionItemViewModel(name: name, isSelected: selectedPositions.contains(name))
    }
    
    var accountService: AccountServicing
    
    init(accountService: AccountServicing) {
        self.accountService = accountService
    }
}
