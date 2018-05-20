//
//  UIButtonExtensions.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import UIKit

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 800043
        if show {
            self.isEnabled = false;
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            self.setTitleColor(self.titleColor(for: .normal)?.withAlphaComponent(0), for: .normal)
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.setTitleColor(self.titleColor(for: .normal)?.withAlphaComponent(1), for: .normal)
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
