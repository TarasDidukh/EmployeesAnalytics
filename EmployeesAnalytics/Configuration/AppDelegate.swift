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
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var reachabilityManager = NetworkReachabilityManager()
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
        
        container.storyboardInitCompleted(EditProfileView.self){ r, c in
            c.viewModel = r.resolve(EditProfileViewModeling.self)
        }
        
        container.storyboardInitCompleted(EmployeesView.self){ r, c in
            c.viewModel = r.resolve(EmployeesViewModeling.self)
        }
        
        container.storyboardInitCompleted(PickPositionsView.self){ r, c in
            c.viewModel = r.resolve(PickPositionsViewModeling.self)
        }
        
        container.register(Networking.self) { _ in Network() }
        
        container.register(AuthenticationServicing.self) { r in
            AuthenticationService(network: r.resolve(Networking.self)!)
        }
        
        container.register(AccountServicing.self) { r in
            AccountService(network: r.resolve(Networking.self)!)
        }
        
        container.register(ExternalAppChanneling.self) { _ in ExternalAppChannel() }
        
        container.register(ProfileViewModeling.self) { r in
            ProfileViewModel(externalAppChannel: r.resolve(ExternalAppChanneling.self)!, accountService: r.resolve(AccountServicing.self)!)
        }
        
        container.register(EditProfileViewModeling.self) { r in
            EditProfileViewModel(accountService: r.resolve(AccountServicing.self)!)
        }
        
        container.register(PickPositionsViewModeling.self) { r in
            PickPositionsViewModel(accountService: r.resolve(AccountServicing.self)!)
            
        }
        
        container.register(SigninViewModeling.self) { r in
            SigininViewModel(authenticationService: r.resolve(AuthenticationServicing.self)!)
        }
        
        container.register(EmployeesViewModeling.self) { r in
            EmployeesViewModel(accountService: r.resolve(AccountServicing.self)!, externalAppChannel: r.resolve(ExternalAppChanneling.self)!)
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
        
       // observeNetworkConnection()
        
        return true
    }
    
    func observeNetworkConnection() {
        let headerView = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 25))
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
        
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
                isNetworkReachable == true {
                headerView.removeFromSuperview()
            } else {
//                if !(UIApplication.shared.visibleViewController is SigninView) && !(UIApplication.shared.visibleViewController is PickPositionsView) {
//                    UIApplication.shared.visibleViewController?.view.addSubview(headerView)
//                }
            }
        }
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

