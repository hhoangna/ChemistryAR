//
//  PushNotificationService.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import UserNotifications
//
protocol PushNotificationServiceDelegate: class {
    func tapPushNotification(with notificationScreen: NotificationModel)
}

protocol PushNotificationService: class {
    var delegate: PushNotificationServiceDelegate? { get set }

    func setUp()
    func didRegister(with deviceToken: Data)

    func startPushNotifications()
    func stopPushNotifications()
}

//MARK: - PushNotificationService_
class PushNotificationService_: NSObject, PushNotificationService {

    weak var delegate: PushNotificationServiceDelegate?

    override init() {
        super.init();

        setUp();
    }

    func setUp() {
        UNUserNotificationCenter.current().delegate = self
    }

    func startPushNotifications() {
        UIApplication.shared.registerForRemoteNotifications()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
                (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    func stopPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            //UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func didRegister(with deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        print("==>DEVICE TOKEN: \( tokenString )");
        SERVICES().firebase.setPUSHToken(deviceToken);
        Caches().setObject(obj: tokenString, forKey: USER_DEFAULT_KEY.HF_DEVICE_TOKEN)
    }
}

//MARK: - PushNotificationsService_ - utilities
fileprivate extension PushNotificationService_ {
    func handleTapReceiveNotificaton(response: UNNotificationResponse) {
        let content = response.notification.request.content;
        
        if let dic = content.userInfo as? ResponseDictionary {
            do {
                let data: Data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let obj = try decoder.decode(NotificationModel.self, from: data)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {  [weak self] in
                    self?.delegate?.tapPushNotification(with: obj)
                }
            } catch let err {
                print("Err:", err)
            }
        }
    }
}

//MARK: - PushNotificationsService_ (UNUserNotificationCenterDelegate)
extension PushNotificationService_: UNUserNotificationCenterDelegate {
    // TODO: Update this method to handle incoming alerts when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo as? [String: Any]
        print("===>Will Present Notification: \(userInfo ?? [:])")
        completionHandler([.alert,.badge,.sound])
        self.perform(#selector(refetchCountNotification), with: nil, afterDelay: 0.025)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        handleTapReceiveNotificaton(response: response)
        
        completionHandler()
    }
    
    @objc func refetchCountNotification() {
        App().settingVC?.tbvContent?.reloadData()
    }
}
