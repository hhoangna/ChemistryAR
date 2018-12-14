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
import Firebase
import ARKit
import ESTabBarController_swift
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var rootNV: CustomNavigationBar?
    var mainVC: MainVC?
    var settingVC: SettingVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        Configuration.enableConfiguration()
        LanguageHelper.setLanguage(forLanguage: .EN)
        SERVICES().push.startPushNotifications()
        SERVICES().push.delegate = self
        
        SERVICES().firebase.setupFirebase()

        checkStatusLogin()

        return true
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return navigationController.topViewController!.supportedInterfaceOrientations
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.refreshBadgeIconNumber()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.refreshBadgeIconNumber()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.refreshBadgeIconNumber()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.refreshBadgeIconNumber()
        App().updateHistoryNotifyList()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.refreshBadgeIconNumber()
        
        // Inscrease of Notification screen refres this screen
        App().updateHistoryNotifyList()
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func checkStatusLogin() {
        if rootNV == nil {
            rootNV = window?.rootViewController as? CustomNavigationBar
            rootNV?.delegate = self
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
        if Caches().user.active ?? true {
            let mainVC:MainVC = .load(SB: .Main)
            rootNV?.setViewControllers([mainVC], animated: false)
            self.mainVC = mainVC
        } else {
            let mainVC:ProfileVC = .load(SB: .Setting)
            mainVC.userModel = Caches().user
            mainVC.mode = .modeNew
            rootNV?.setViewControllers([mainVC], animated: false)
        }
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

extension AppDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SERVICES().push.didRegister(with: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register Remote Notification: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.refreshBadgeIconNumber()
    }
}

extension AppDelegate: PushNotificationServiceDelegate {
    
    func tapPushNotification(with notificationScreen: NotificationModel) {
        NotificationModel.getVCFrom(notiData: notificationScreen) { (success, vc) in
            if success{
                App().settingVC?.tbvContent?.reloadData()
                App().rootNV?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func refreshBadgeIconNumber()  {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            DispatchQueue.main.async {
                let count:Int = notifications.count
                UIApplication.shared.applicationIconBadgeNumber = count
                
                let user:UserDefaults = UserDefaults.standard
                user.set(count, forKey: "AppBadge")
            }
        }
    }
    
    func removeNotification(_ notiId:String) {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            notifications.forEach { (notification) in
                let content:UNNotificationContent = notification.request.content
                if let userInfo:ResponseDictionary = content.userInfo as? ResponseDictionary{
                    if let screen = userInfo["screen"] as? ResponseDictionary {
                        if let id = screen["_id"] as? String{
                            if id == notiId {
                                self.removeReadNotification(notification: notification.request)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let user:UserDefaults = UserDefaults.standard
        user.set(0, forKey: "AppBadge")
    }
    
    func removeReadNotification(notification:UNNotificationRequest)  {
        UIView.animate(withDuration: 0, animations: {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.identifier])
        }) { (success) in
            App().settingVC?.tbvContent?.reloadData()
        }
    }
    
    func updateHistoryNotifyList() {
//        if vc is NotificationVC {
//            (vc as? NotificationVC)?.onPullRefresh()
//        }
        
        App().settingVC?.tbvContent?.reloadData()
    }
}
