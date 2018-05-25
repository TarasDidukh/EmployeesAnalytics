//
//  EditProfileView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/23/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import ReactiveSwift
import Result
import ReactiveCocoa

class EditProfileView: UIViewController, UITableViewDataSource, UITableViewDelegate, ResultViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var pickPhotoButton: UIView!
    @IBOutlet weak var pickPhotoIcon: UIImageView!
    @IBOutlet weak var nameField: ACFloatingTextfield!
    @IBOutlet weak var lastNameField: ACFloatingTextfield!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionTable: UITableView!
    @IBOutlet weak var editIcon: UIImageView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var bottomLineTable: UIView!
    @IBOutlet weak var emailField: ACFloatingTextfield!
    @IBOutlet weak var phoneField: ACFloatingTextfield!
    @IBOutlet weak var skypeField: ACFloatingTextfield!
    @IBOutlet weak var containerScroll: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightTableContraint: NSLayoutConstraint!
    @IBOutlet weak var lastFieldBottomContraint: NSLayoutConstraint!
    private var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    private var isInit = false
    
    let picker = UIImagePickerController()

    
    public var viewModel: EditProfileViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
        avatarImage.layer.cornerRadius = 55
        avatarImage.layer.masksToBounds = false
        avatarImage.clipsToBounds = true


        pickPhotoButton.layer.cornerRadius = 14
        pickPhotoButton.layer.masksToBounds = true
        pickPhotoIcon.tintColor = UIColor.white
        positionTable.delegate = self
        positionTable.dataSource = self
        
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                self.dismiss(animated: true, completion: nil)
                observer.sendCompleted()
            }
        }))
        
//        navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
//            return SignalProducer { observer, disposable in
//                self.performSegue(withIdentifier: "showPickPositions", sender: nil)
//                observer.sendCompleted()
//            }
//        }))
        
        navigationItem.title = NSLocalizedString("ProfileEdit", comment: "")
        
        containerScroll.bounces = false
        
        nameField.placeholder = NSLocalizedString("Name", comment: "")
        nameField.config()
        
        lastNameField.placeholder = NSLocalizedString("LastName", comment: "")
        lastNameField.config()
        
        positionLabel.textColor = AppColors.GrayTextColor
        positionLabel.text = NSLocalizedString("Position", comment: "")
        editLabel.textColor = AppColors.MainBlue
        editIcon.tintColor = AppColors.MainBlue
        bottomLineTable.backgroundColor = AppColors.FieldLineColor
        
        emailField.placeholder = NSLocalizedString("Email", comment: "")
        emailField.config()
        
        phoneField.placeholder = NSLocalizedString("Phone", comment: "")
        phoneField.config()
        
        skypeField.placeholder = NSLocalizedString("Skype", comment: "")
        skypeField.config()
        
        isInit = true
        positionTable.bounces = false
        
        let panTable = UITapGestureRecognizer(target: self, action: #selector(self.tapPositionTable))
        panTable.numberOfTapsRequired = 1
        
        
        positionTable.addGestureRecognizer(panTable)
        
        let panAvatar = UITapGestureRecognizer(target: self, action: #selector(self.tapAvatar))
        panAvatar.numberOfTapsRequired = 1
        let panAvatarImage = UITapGestureRecognizer(target: self, action: #selector(self.tapAvatar))
        panAvatarImage.numberOfTapsRequired = 1
        avatarImage.addGestureRecognizer(panAvatarImage)
        avatarImage.isUserInteractionEnabled = true
        pickPhotoButton.addGestureRecognizer(panAvatar)
        
        
        positionTable.addGestureRecognizer(panTable)
        
        //self.positionTable.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    func send(result: Any) {
        if let positions = result as? [String] {
            viewModel?.positions.value = positions
        }
    }
    
    func bindView() {
        if let viewModel = viewModel {
            nameField.reactive.text <~ viewModel.name
            viewModel.name <~ nameField.reactive.textValues
            lastNameField.reactive.text <~ viewModel.lastName
            viewModel.lastName <~ lastNameField.reactive.textValues
            emailField.reactive.text <~ viewModel.email
            viewModel.email <~ emailField.reactive.textValues
            phoneField.reactive.text <~ viewModel.phone
            viewModel.phone <~ phoneField.reactive.textValues
            skypeField.reactive.text <~ viewModel.skype
            viewModel.skype <~ skypeField.reactive.textValues
            
            viewModel.name.result.signal.observeValues { result in
                let error = result.error?.reason
                if (error ?? "").isEmpty {
                    self.nameField.hideError()
                } else {
                    self.nameField.showErrorWithText(errorText: error!)
                }
            }
            
            viewModel.lastName.result.signal.observeValues { result in
                let error = result.error?.reason
                if (error ?? "").isEmpty {
                    self.lastNameField.hideError()
                } else {
                    self.lastNameField.showErrorWithText(errorText: error!)
                }
            }
            
            viewModel.email.result.signal.observeValues { result in
                let error = result.error?.reason
                if (error ?? "").isEmpty {
                    self.emailField.hideError()
                } else {
                    self.emailField.showErrorWithText(errorText: error!)
                }
            }
            
            viewModel.positions.signal.observe(on: UIScheduler()).observeValues { _ in
                self.positionTable.reloadData()
                self.heightTableContraint.constant = self.positionTable.contentSize.height
            }
            
            viewModel.avatar.signal.observeValues({ url in
                if let url = url, !url.isEmpty {
                    self.avatarImage.kf.setImage(with: URL(string: url))
                }
            })
        }
    }
    
    @objc func tapPositionTable() {
        self.performSegue(withIdentifier: "showPickPositions", sender: nil)
    }
    
    @objc func tapAvatar() {
        let actionPopup = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionPopup.addAction(UIAlertAction(title: NSLocalizedString("FromGallery", comment: ""), style: .default, handler: { _ in
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionPopup.addAction(UIAlertAction(title: NSLocalizedString("FromCamera", comment: ""), style: .default, handler: { _ in
                let imagePickerController = UIImagePickerController()
                
                imagePickerController.sourceType = .camera
                
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        actionPopup.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: nil))
        
       present(actionPopup, animated: true, completion: nil)
    }
    
    
    //MARK: - Delegates picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return;
        }
        avatarImage.image = selectedImage.cropCenter(width: Double(avatarImage.frame.width), height: Double(avatarImage.frame.height))
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPickPositions" {
            let nav = segue.destination as! UINavigationController
            let pickPositionsView: PickPositionsView = nav.topViewController as! PickPositionsView
            if let viewModel = viewModel {
                pickPositionsView.viewModel?.selectedPositions = viewModel.positions.value
                pickPositionsView.resultViewDelegate = self
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.lastFieldBottomContraint.constant = 25
            self.containerScroll.contentOffset = self.lastOffset
        })
    }
    
     @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.lastFieldBottomContraint.constant = keyboardFrame.height + 20
        
        if let focusedView = getFirstResponder() {
            let distanceToBottom = self.containerScroll.frame.size.height - focusedView.frame.origin.y - focusedView.frame.size.height
            let collapseSpace = keyboardFrame.height - distanceToBottom
            if collapseSpace < 0 {
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerScroll.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    func getFirstResponder() -> UIView? {
        for subView in self.containerView.subviews {
            if subView.isFirstResponder {
                return subView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.positions.value.count
        }
        return 0
    }

    override func viewDidAppear(_ animated: Bool) {
        heightTableContraint.constant = positionTable.contentSize.height
        lastOffset = self.containerScroll.contentOffset
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "positionItem", for: indexPath)
        let positionName = UILabel(frame: CGRect(x: 0, y: 0, width: positionTable.frame.width, height: 44))
        positionName.text = viewModel?.positions.value[indexPath.row]
        positionName.font = UIFont(name: "HelveticaNeue", size: 14)
        positionName.textColor = UIColor.black
        positionName.tag = 904324
        if let label = cell.contentView.viewWithTag(positionName.tag) as? UILabel {
            label.removeFromSuperview()
        }
        cell.contentView.addSubview(positionName)
        return cell
    }
}
