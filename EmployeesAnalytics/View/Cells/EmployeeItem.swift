//
//  EmployeeItem.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import Kingfisher

class EmployeeItem: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var viewModel: EmployeeItemViewModeling? {
        didSet {
            userNameLabel.text = viewModel?.userName
            positionLabel.text = viewModel?.position
            if let viewModel = viewModel, viewModel.avatar != nil, !viewModel.avatar!.isEmpty {
                let processor = RoundCornerImageProcessor(cornerRadius: 37)
                self.avatarImage.kf.setImage(with: URL(string: viewModel.avatar!), options: [.processor(processor)])
            }
            else {
                avatarImage.image = UIImage(named: "noAvatar")
                avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        positionLabel.textColor = AppColors.GrayTextColor
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
