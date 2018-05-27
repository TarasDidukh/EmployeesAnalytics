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

class ProfileView: UIViewController, ResultViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
//    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var phoneLabel: UILabel!
//    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var profileInfoTable: UITableView!
    
    public var viewModel: ProfileViewModeling?
    public var resultViewDelegate: ResultViewDelegate?
    
    private var editButton: UIBarButtonItem?
    private var backButton: UIBarButtonItem?
    @IBOutlet weak var editSavedContainer: UIView!
    @IBOutlet weak var editSavedCenter: UIView!
    @IBOutlet weak var editSavedLabel: UILabel!
    @IBOutlet weak var profileInfoTableWidth: NSLayoutConstraint!
    
    var infoTitles = ["Email:", "Phone:", "Skype:"]
    public var isBackActive = true
    var isProfileEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //observeNetworkConnection()
        avatarImage.image = UIImage(named: "noAvatar")
        avatarImage.tintColor = AppColors.GrayIconTint
        
        editButton = navigationItem.rightBarButtonItem
        backButton = navigationItem.leftBarButtonItem
        callButton.isHidden = true
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = NSLocalizedString("Profile", comment: "")
        
        if !isBackActive {
            navigationItem.leftBarButtonItem = nil
        }
        
        bindView()
        
        profileInfoTable.delegate = self
        profileInfoTable.dataSource = self
        profileInfoTable.bounces = false
        profileInfoTable.isUserInteractionEnabled = false
        
        avatarImage.layer.cornerRadius = 55
        avatarImage.layer.masksToBounds = true
        positionLabel.textColor = AppColors.GrayTextColor
        
        editSavedContainer.backgroundColor = AppColors.MainBlue
        editSavedCenter.backgroundColor = AppColors.MainBlue
        editSavedLabel.text = NSLocalizedString("ChangesSaved", comment: "")
        editSavedContainer.isHidden = true
        
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
            viewModel.avatarUrl.producer.observe(on: UIScheduler())
                .on(value: { url in
                    let placeholder = UIImageView(image: UIImage(named: "noAvatar"))
                    placeholder.tintColor = AppColors.GrayIconTint
                    self.avatarImage.image = nil
                    if let url = url, !url.isEmpty {
                        self.avatarImage.kf.setImage(with: URL(string: url), placeholder: placeholder)
                    } else {
                         self.avatarImage.kf.setImage(with: URL(string: ""), placeholder: placeholder)
                    }
                }).start()
            
            userNameLabel.reactive.text <~ viewModel.userName
            positionLabel.reactive.text <~ viewModel.position
            viewModel.profileInfo.signal.observeValues { _ in
                self.profileInfoTable.reloadData()
            }
            
            callButton.reactive.controlEvents(.touchUpInside).signal.throttle(1.5, on: QueueScheduler.main).observeValues { _ in
                if !viewModel.Call!.isExecuting.value {
                    viewModel.Call!.apply().start()
                }
            }
            viewModel.IsMyProfile.producer.observe(on: UIScheduler()).on { (value) in
                if value == false {
                    self.callButton.isHidden = false
                }
                if viewModel.checkAvailableEdit() {
                    self.navigationItem.rightBarButtonItem = self.editButton
                }
            }.start()
            
            navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
                return SignalProducer { observer, disposable in
                    self.dismiss(animated: true, completion: nil)
                    if self.isProfileEdited {
                        self.resultViewDelegate?.send(result: viewModel.employee)
                    }
                    observer.sendCompleted()
                }
            }))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeNetworkConnection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        maxWidth = []
        if let viewModel = viewModel {
            return viewModel.profileInfo.value.count
        }
        return 0
    }
    
    var maxWidth: [CGFloat] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoItem
        
        cell.titleInfoLabel.text = infoTitles[indexPath.row]
        cell.descriptionInfoLabel.text = viewModel?.profileInfo.value[indexPath.row]
        
        maxWidth.append(NSString(string: cell.descriptionInfoLabel.text!).size(withAttributes: [NSAttributedStringKey.font: UIFont(name:"HelveticaNeue-Bold", size: 14.0)]).width + cell.descriptionInfoLabel.frame.origin.x + 10)
        if indexPath.row + 1 == profileInfoTable.numberOfRows(inSection: 0) {
            var newFrame = profileInfoTable.frame;
            newFrame.size.width = maxWidth.max()!
            newFrame.origin.x = (UIScreen.main.bounds.width - newFrame.size.width) / 2
            tableView.frame = newFrame;
             profileInfoTableWidth.constant = newFrame.size.width
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditProfileView" {
            let nav = segue.destination as! UINavigationController
            let editProfileView: EditProfileView = nav.topViewController as! EditProfileView
            editProfileView.resultViewDelegate = self
            if let employee = viewModel?.employee {
                editProfileView.viewModel?.employee = employee
            }
        }
    }
    
    func send(result: Any) {
        if let employee = result as? Employee {
            if viewModel?.IsMyProfile.value == true && !isBackActive {
                let menuView: MenuView = sideMenuController?.sideViewController as! MenuView
                menuView.viewModel?.employee = employee
            } else {
                viewModel?.employee = employee
            }
            
           isProfileEdited = true
            
            self.editSavedContainer.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.editSavedContainer.isHidden = true
            }
        }
    }
    
    
}
