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
    
    private var editButton: UIBarButtonItem?
    private var backButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.image = UIImage(named: "noAvatar")
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
        
        editButton = navigationItem.rightBarButtonItem
        backButton = navigationItem.leftBarButtonItem
        navigationItem.leftBarButtonItem = nil
        callButton.isHidden = true
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = NSLocalizedString("Profile", comment: "")
        
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
            
//            callButton.reactive.isEnabled <~ viewModel.Call!.isExecuting.signal.delay(1, on: QueueScheduler.main).map({
//                !$0
//            })
            callButton.reactive.controlEvents(.touchUpInside).signal.throttle(1.5, on: QueueScheduler.main).observeValues { _ in
                if !viewModel.Call!.isExecuting.value {
                    viewModel.Call!.apply().start()
                }
            }
//                { _ in
//                self.callButton.isEnabled = false
//            }
            viewModel.IsMyProfile.producer.observe(on: UIScheduler()).on { (value) in
                if value == true {
                    self.navigationItem.rightBarButtonItem = self.editButton
                } else if value == false {
                    self.navigationItem.leftBarButtonItem = self.backButton
                    self.callButton.isHidden = false
                }
            }.start()
            
            navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
                return SignalProducer { observer, disposable in
                    self.dismiss(animated: true, completion: nil)
                    observer.sendCompleted()
                }
            }))
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditProfileView" {
            let nav = segue.destination as! UINavigationController
            let editProfileView: EditProfileView = nav.topViewController as! EditProfileView
            if let employee = viewModel?.employee {
                editProfileView.viewModel?.employee = employee
            }
        }
    }
    
    
}
