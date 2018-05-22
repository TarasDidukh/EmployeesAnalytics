//
//  SwinjectStoryboard+Setup.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/18/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation
import SwinjectStoryboard

//extension SwinjectStoryboard {
//    @objc class func setup() {
//        defaultContainer.storyboardInitCompleted(SigninView.self) { r, c in
//           c.viewModel = r.resolve(SigninViewModeling.self)
//        }
//        
//        defaultContainer.storyboardInitCompleted(RootMenuView.self){_,_ in }
//        defaultContainer.storyboardInitCompleted(MenuView.self){_,_ in }
//        defaultContainer.storyboardInitCompleted(EmployeesView.self){_,_ in }
//        
//        defaultContainer.register(Networking.self) { _ in Network() }
//        
//        defaultContainer.register(AuthenticationServicing.self) { r in
//            AuthenticationService(network: r.resolve(Networking.self)!)
//        }
//        
//        defaultContainer.register(SigninViewModeling.self) { r in
//            SigininViewModel(authenticationService: r.resolve(AuthenticationServicing.self)!)
//        }
//    }
//}
