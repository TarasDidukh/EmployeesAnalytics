//
//  UIControllerExtensions.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

extension UIViewController {
    func displayAlert(title: String = "", message: String = "")
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func observeNetworkConnection(_ addTopPadding: Bool = true) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        let tag = 800055
        headerView.tag = tag
        if addTopPadding {
            headerView.frame.origin.y = 64
        }
        headerView.backgroundColor = AppColors.MainBlue
        let labelText = NSLocalizedString("ConnectionLost", comment: "")
        var headerCenterWidth = NSString(string: labelText).size(withAttributes: [NSAttributedStringKey.font: UIFont(name:"HelveticaNeue", size: 12.0)]).width + 35
        let headerCenterView = UIView(frame: CGRect(x: (UIScreen.main.bounds.width - headerCenterWidth)/2, y: 0, width: headerCenterWidth, height: 25))
        headerCenterView.backgroundColor = AppColors.MainBlue
        let icon = UIImageView(frame: CGRect(x: 0, y: 4.5, width: 16, height: 16))
        icon.image = UIImage(named: "wifi")
        headerCenterView.addSubview(icon)
        let label = UILabel(frame: CGRect(x: 25, y: 4.5, width: headerCenterWidth - 25, height: 16))
        label.text = labelText
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        headerCenterView.addSubview(label)
        headerView.addSubview(headerCenterView)
        let reachabilityManager = (UIApplication.shared.delegate as! AppDelegate).reachabilityManager
        
        checkStatus(reachabilityManager?.networkReachabilityStatus ?? NetworkReachabilityManager.NetworkReachabilityStatus.notReachable, headerView, tag)
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { status in
            self.checkStatus(status, headerView, tag)
        }
        
    }
    
    private func checkStatus(_ status: NetworkReachabilityManager.NetworkReachabilityStatus, _ headerView: UIView, _ tag: Int) {
        switch status {
        case .notReachable, .unknown:
            if self.view.viewWithTag(tag) == nil {
                self.view.addSubview(headerView)
            }
        case .reachable(_):
            if let view = self.view.viewWithTag(tag) {
                view.removeFromSuperview()
            }
        }
    }
}
