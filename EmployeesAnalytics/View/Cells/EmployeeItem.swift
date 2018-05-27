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
import ReactiveSwift
import ReactiveCocoa

extension UIImageView: Placeholder {}

class EmployeeItem: SwipeTableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var disposableAvatar: Disposable?
    
    var viewModel: EmployeeItemViewModeling? {
        didSet {
            if let viewModel = viewModel {
                positionLabel.reactive.text <~ viewModel.position
                userNameLabel.reactive.attributedText <~ viewModel.userName.map({ (value) -> NSMutableAttributedString  in
                    let userNamePrepared = NSMutableAttributedString(attributedString: (value?.htmlToAttributedString)!)
                    userNamePrepared.setFontFace(font: UIFont(name: "HelveticaNeue", size: 16)!)
                    return userNamePrepared
                })
                disposableAvatar?.dispose()
                
                disposableAvatar = viewModel.avatar.producer.observe(on: UIScheduler())
                    .on(value: { url in
                        self.avatarImage.image = nil
                        if  !(url ?? "").isEmpty {
                            let processor = RoundCornerImageProcessor(cornerRadius: 20)
                            let placeholder = UIImageView(image: UIImage(named: "refresh"))
                            
                            placeholder.image = placeholder.image?.imageWithInsets(insetDimen: 15).withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            placeholder.tintColor = AppColors.GrayIconTint
                            self.avatarImage.kf.setImage(with: URL(string: viewModel.avatar.value!), placeholder: placeholder, options: [.processor(processor)])
                        } else {
                            self.avatarImage.image = UIImage(named: "noAvatar")
                        }
                    }).start()
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        positionLabel.textColor = AppColors.GrayTextColor
        avatarImage.tintColor = AppColors.GrayIconTint
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.avatarImage.kf.setImage(with: URL(string: ""))
    }

}
