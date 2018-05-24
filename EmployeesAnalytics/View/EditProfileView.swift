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

class EditProfileView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var pickPhotoButton: UIView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.tintColor = AppColors.MenuHeaderBackgroundColor
        avatarImage.layer.cornerRadius = 55
        avatarImage.layer.masksToBounds = true
        pickPhotoButton.layer.cornerRadius = 14
        pickPhotoButton.layer.masksToBounds = true
        positionTable.delegate = self
        positionTable.dataSource = self
        
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                self.dismiss(animated: true, completion: nil)
                observer.sendCompleted()
            }
        }))
        
        navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                self.performSegue(withIdentifier: "showPickPositions", sender: nil)
            }
        }))
        
        
        
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
        return 3
    }

    override func viewDidAppear(_ animated: Bool) {
        heightTableContraint.constant = positionTable.contentSize.height
        lastOffset = self.containerScroll.contentOffset
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "positionItem", for: indexPath)
        //cell.frame = CGRect(x: 0, y: 0, width: positionTable.frame.width, height: 44)
        //cell.textLabel?.text = "!1111111111"
        var test = UILabel(frame: CGRect(x: 0, y: 0, width: positionTable.frame.width, height: 44))
        test.text = "454343$"
        test.textColor = UIColor.black
        cell.contentView.addSubview(test)
        
        return cell
    }
}
