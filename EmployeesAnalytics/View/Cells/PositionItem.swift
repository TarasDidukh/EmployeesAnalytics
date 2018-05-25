//
//  PositionItem.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class PositionItem: UITableViewCell {
    @IBOutlet weak var checkmarkIcon: UIImageView!
    @IBOutlet weak var positionNameLabel: UILabel!
    var disposeObserver: Disposable?
    
    var viewModel: PositionItemViewModeling? {
        didSet {
            if let viewModel = viewModel {
                positionNameLabel.text = viewModel.name
                disposeObserver?.dispose()
                
                disposeObserver = viewModel.isSelected.producer.observe(on: UIScheduler()).on { (value) in
                    self.checkmarkIcon.tintColor = value ? AppColors.MainBlue : UIColor.white
                }.start()
//                checkmarkIcon.reactive.tintColor <~ viewModel.isSelected.map({ (value) -> UIColor in
//                    return value ? AppColors.MainBlue : UIColor.white
//                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkmarkIcon.layer.cornerRadius = 9;
        checkmarkIcon.layer.masksToBounds = true
        checkmarkIcon.layer.borderColor = AppColors.BorderImageColor.cgColor
        checkmarkIcon.layer.borderWidth = 1
        checkmarkIcon.image = UIImage(named: "checkmark")
        checkmarkIcon.tintColor = UIColor.white
    }

}
