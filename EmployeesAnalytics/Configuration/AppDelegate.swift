//
//  AppDelegate.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/18/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import SideMenuController
import SwinjectStoryboard
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: Container = {
        let container = Container()
        container.storyboardInitCompleted(SigninView.self) { r, c in
            c.viewModel = r.resolve(SigninViewModeling.self)
        }
        container.storyboardInitCompleted(RootMenuView.self){_,_ in }
        container.storyboardInitCompleted(MenuView.self) { r, c in
            c.viewModel = r.resolve(MenuViewModeling.self)
        }
        
        container.storyboardInitCompleted(ProfileView.self) { r, c in
            c.viewModel = r.resolve(ProfileViewModeling.self)
        }
        
        container.storyboardInitCompleted(EmployeesView.self){ r, c in
            c.viewModel = r.resolve(EmployeesViewModeling.self)
        }
        
        container.register(Networking.self) { _ in Network() }
        
        container.register(AuthenticationServicing.self) { r in
            AuthenticationService(network: r.resolve(Networking.self)!)
        }
        
        container.register(AccountServicing.self) { r in
            AccountService(network: r.resolve(Networking.self)!)
        }
        
        container.register(ProfileViewModeling.self) { _ in ProfileViewModel() }
        
        container.register(SigninViewModeling.self) { r in
            SigininViewModel(authenticationService: r.resolve(AuthenticationServicing.self)!)
        }
        
        container.register(EmployeesViewModeling.self) { r in
            EmployeesViewModel(accountService: r.resolve(AccountServicing.self)!)
        }
        
        container.register(MenuViewModeling.self) { r in
            MenuViewModel(authenticationService: r.resolve(AuthenticationServicing.self)!, accountService: r.resolve(AccountServicing.self)!)
        }
        
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "iconMenu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        UIApplication.shared.statusBarView?.backgroundColor = .black
        UIApplication.shared.statusBarStyle = .lightContent
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        var initView = "SigninView"
        
        if container.resolve(AuthenticationServicing.self)!.checkAuthentication() {
            initView = "RootMenuView"
        }
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: initView)
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

