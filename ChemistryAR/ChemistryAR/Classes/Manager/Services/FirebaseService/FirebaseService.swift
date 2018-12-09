//
//  FirebaseService.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging

/// Service for Firebase details based on the BuildConfiguration
class FirebaseService:NSObject {
    /*
    let tokenType:  MessagingAPNSTokenType;
    let options: FirebaseOptions;
 */
    override init() {
        super.init()
    }
    /*
    init(buildConf conf: BuildConfiguration? = nil) {
        
        var plistPath: String;
        
        if let confBuild = conf  {
            switch confBuild.buildScheme {
            case .debug, .adhoc:
                tokenType = .sandbox
                plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
                
            case .release:
                tokenType = .prod
                plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
            }
            
        }else {
            tokenType = .unknown
            plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        }
        
        options = FirebaseOptions(contentsOfFile: plistPath)!;
    }
 */
    
    func setupFirebase() {
        let  plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        let option = FirebaseOptions(contentsOfFile: plistPath)
        FirebaseApp.configure(options: option!)
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func setPUSHToken(_ token: Data)  {
        Messaging.messaging().setAPNSToken(token, type: .sandbox)
    }
}

//MARK: - MessagingDelegate
extension FirebaseService: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("==>Did receive FCM token: \(fcmToken)")
        
        Caches().setObject(obj: fcmToken, forKey: USER_DEFAULT_KEY.HF_FCM_TOKEN)
        // Update FCM token to service .
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("==>didReceive remote message: \(remoteMessage.appData)")
    }
}
