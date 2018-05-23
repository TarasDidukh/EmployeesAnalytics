//
//  FloatingTextFieldExtension.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/23/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import ACFloatingTextfield_Swift

extension ACFloatingTextfield {
    func config() {
        self.lineColor = AppColors.FieldLineColor
        self.selectedLineColor = AppColors.FieldSelectedLineColor
        self.placeHolderColor = AppColors.FieldPlaceholderColor
        self.selectedPlaceHolderColor = AppColors.FieldSelectedPlaceholderColor
        self.errorTextColor = AppColors.FieldErrorColor
        self.shakeLineWithError = false
    }
}
