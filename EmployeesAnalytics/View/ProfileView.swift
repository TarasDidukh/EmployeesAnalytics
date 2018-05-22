//
//  ProfileView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class ProfileView: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    public var viewModel: ProfileViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.image = UIImage(named: "noAvatar")
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
        
         bindView()
        
        
        avatarImage.layer.cornerRadius = 55
        avatarImage.layer.masksToBounds = true
        positionLabel.textColor = AppColors.GrayTextColor
        
        callButton.layer.cornerRadius = 25
        callButton.backgroundColor = AppColors.ButtonBackground
        callButton.layer.shadowOffset = CGSize(width: 0, height: 7.5)
        callButton.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        callButton.layer.shadowOpacity = 1
        callButton.layer.shadowRadius = 15
        callButton.imageView?.tintColor = UIColor.white
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.avatarUrl.producer
                .on(value: { url in
                    if let url = url, !url.isEmpty {
                        self.avatarImage.kf.setImage(with: URL(string: url))
                    }
                }).start()
            
            userNameLabel.reactive.text <~ viewModel.userName
            positionLabel.reactive.text <~ viewModel.position
            emailLabel.reactive.text <~ viewModel.email
            skypeLabel.reactive.text <~ viewModel.skype
            phoneLabel.reactive.text <~ viewModel.phone
            
            
            
            if viewModel.IsMyProfile {
                navigationItem.leftBarButtonItem = nil
                callButton.isHidden = true
            } else {
                navigationItem.rightBarButtonItem = nil
            }
            
            navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
                return SignalProducer { observer, disposable in
                    self.dismiss(animated: true, completion: nil)
                    observer.sendCompleted()
                }
            }))
        }
    }
    
    
}
