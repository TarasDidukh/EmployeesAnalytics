//
//  EmployeeItem.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import Kingfisher
import SwipeCellKit

extension UIImageView: Placeholder {}

class EmployeeItem: SwipeTableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var viewModel: EmployeeItemViewModeling? {
        didSet {
            userNameLabel.text = viewModel?.userName
            positionLabel.text = viewModel?.position
            if let viewModel = viewModel, viewModel.avatar != nil, !viewModel.avatar!.isEmpty {
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                let placeholder = UIImageView(image: UIImage(named: "refresh"))
                placeholder.tintColor = AppColors.GrayIconTint
                self.avatarImage.kf.setImage(with: URL(string: viewModel.avatar!), placeholder: placeholder, options: [.processor(processor)])
                
            }
            else {
                avatarImage.image = UIImage(named: "noAvatar")
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        positionLabel.textColor = AppColors.GrayTextColor
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
