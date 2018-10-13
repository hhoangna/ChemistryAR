//
//  AppDelegate.swift
//  ChemistryAR
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager
import SwiftMessages
import ESTabBarController_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var rootNV: BaseNV?
    var mainVC: MainVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        LanguageHelper.setLanguage(forLanguage: .EN)
        
        checkStatusLogin()
        
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
    
    func checkStatusLogin() {
        if rootNV == nil {
            rootNV = window?.rootViewController as? BaseNV
        }
        if Caches().hasLogin {
            onLoginSuccess()
        }else {
            onReLogin()
        }
    }
    
    func onReLogin()  {
        let vc:LoginVC = .load(SB: .Login)
        rootNV?.setViewControllers([vc], animated: false)
        Caches().removeAllCache()
    }
    
    func onLoginSuccess()  {
        let mainVC:MainVC = .load(SB: .Main)
        rootNV?.setViewControllers([mainVC], animated: false)
        self.mainVC = mainVC
    }

    public func showLoadingIndicator(_ atView:UIView? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let view = atView {
            SVProgressHUD.setContainerView(view)
        }
        SVProgressHUD.setBorderWidth(0.5)
        SVProgressHUD.setBorderColor(UIColor.lightGray)
        SVProgressHUD.show()
    }
    
    public func dismissLoadingIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }
    
    public func showMessageNotice(title: String, presentationStyle: SwiftMessages.PresentationStyle, styleView: MessageView.Layout, styleTheme: Theme) {
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 1)
        config.dimMode = .none
        config.presentationStyle = presentationStyle
        
        let view = MessageView.viewFromNib(layout: styleView)
        view.configureTheme(styleTheme, iconStyle: .default)
        view.configureContent(body: title)
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        
        SwiftMessages.show(config: config, view: view)
    }
        
    public func showSuccessufullIndicator() {
        SVProgressHUD.showSuccess(withStatus: "Successfully")
    }
}

