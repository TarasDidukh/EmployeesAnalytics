//
//  SigninView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import ACFloatingTextfield_Swift
import ReactiveSwift
import ReactiveCocoa
import UIKit

class SigninView: UIViewController {
    @IBOutlet weak var loginField: ACFloatingTextfield!
    @IBOutlet weak var passwordField: ACFloatingTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginBottomCnstr: NSLayoutConstraint!
    @IBOutlet weak var logoTopCnstr: NSLayoutConstraint!
    @IBOutlet weak var logoHeightCnstr: NSLayoutConstraint!
    @IBOutlet weak var logoWidthCnstr: NSLayoutConstraint!
    private var isInit = false
    private var isKeyboardShown = false;
    private var logoTopOrigin: CGFloat = 0
    private var loginBottomOrigin: CGFloat = 0
    private var disposeLogin: Disposable?
    
    public var viewModel: SigninViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        
        loginField.config()
        passwordField.config()
        passwordField.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        loginField.placeholder = NSLocalizedString("LoginPlaceholder", comment: "")
        loginButton.setTitle(NSLocalizedString("LoginTitle", comment: ""), for: .normal)
        
        loginButton.layer.cornerRadius = 25
        loginButton.backgroundColor = AppColors.ButtonBackground
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 7.5)
        loginButton.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        loginButton.layer.shadowOpacity = 1
        loginButton.layer.shadowRadius = 15
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        logoTopOrigin = logoTopCnstr.constant
        loginBottomOrigin = loginBottomCnstr.constant
        isInit = true;
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if isKeyboardShown {
            return
        }
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.loginBottomCnstr.constant = keyboardFrame.size.height + 20
            self.logoTopCnstr.constant = 10
            self.logoWidthCnstr.constant = self.logoWidthCnstr.constant / 1.5
            self.logoHeightCnstr.constant = self.logoHeightCnstr.constant / 1.5
            
        })
        isKeyboardShown = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.loginBottomCnstr.constant = self.loginBottomOrigin
            self.logoTopCnstr.constant = self.logoTopOrigin
            self.logoWidthCnstr.constant = self.logoWidthCnstr.constant * 1.5
            self.logoHeightCnstr.constant = self.logoHeightCnstr.constant * 1.5
        })
        isKeyboardShown = false
    }
    
    private func bindView()
    {
        #if DEBUG
            loginField.text = "botanichek2015@gmail.com"
            passwordField.text = "Bot541138"
        #endif
        
        if let viewModel = viewModel {
            viewModel.email <~ loginField.reactive.textValues
            viewModel.email.result.producer.on { result in
                let error = self.isInit ? result.error?.reason : ""
                if (error ?? "").isEmpty {
                    self.loginField.hideError()
                } else {
                    self.loginField.showErrorWithText(errorText: error!)
                }
            }.start()
            
            viewModel.password <~ passwordField.reactive.textValues
            viewModel.password.result.producer.on { result in
                let error = self.isInit ? result.error?.reason : ""
                if (error ?? "").isEmpty {
                    self.passwordField.hideError()
                } else {
                    self.passwordField.showErrorWithText(errorText: error!)
                }
            }.start()
            
            viewModel.signinError.producer
                .on(value: { error in
                    if let errorMessage = error?.type?.description {
                        self.displayAlert(message: errorMessage)
                    }
                }).start()
            
            loginButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
                self.loginField.resignFirstResponder()
                self.passwordField.resignFirstResponder()
                self.viewModel?.password.value = self.passwordField.text
                self.viewModel?.email.value = self.loginField.text
                
                if let viewModel = self.viewModel
                {
                    self.disposeLogin = viewModel.Signin!.apply(()).observe(on: UIScheduler())
                    .on(starting: {
                        self.loginButton.loadingIndicator(viewModel.Signin?.isEnabled.value ?? false)
                    }, failed: { _ in
                         self.loginButton.loadingIndicator(false)
                    }, completed: {
                        self.loginButton.loadingIndicator(false)
                    }, value: {
                        self.performSegue(withIdentifier: "showRootMenuView", sender: self)
                    }).start()
                    
                }
            }
        }
    }
}
