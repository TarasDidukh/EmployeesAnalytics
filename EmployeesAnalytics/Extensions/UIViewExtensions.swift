//
//  UIViewExtensions.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/22/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func activityIndicator(_ show: Bool, _ y: CGFloat = -1) {
        let tag = 800043
        if show {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            let viewHeight = self.bounds.size.height
            let viewWidth = self.bounds.size.width
            var y = y
            if y < 0 {
                y = viewHeight/2
            }
            indicator.center = CGPoint(x: viewWidth/2, y: y)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func emptyList(_ show: Bool, _ message: String = "", _ y: CGFloat = -1) {
        let tag = 800045
        if show {
            let viewHeight = self.bounds.size.height
            let viewWidth = self.bounds.size.width
            var y = y
            if y < 0 {
                y = viewHeight/2 - 10
            }
            let label = UILabel(frame: CGRect(x: 0, y: y, width: viewWidth, height: 20))
            label.textColor = UIColor.black
            label.text = message
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont(name: "HelveticaNeue", size: 16)
            label.tag = tag
            self.addSubview(label)
        } else {
            if let label = self.viewWithTag(tag) as? UILabel {
                label.removeFromSuperview()
            }
        }
    }
}
