//
//  Services.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation
import Alamofire;

class Services {
    
    //MARK: - Services
    fileprivate(set) lazy var API: BaseAPI = {
        return BaseAPI.shared()
    }()
    
    
//    fileprivate(set) lazy var push: PushNotificationService = {
//        return PushNotificationService_()
//    }()
//    
//    fileprivate(set) lazy var firebase: FirebaseService = {
//        return FirebaseService()
//    }()
    
    
    //MARK: - instances
    fileprivate(set) static var shared: Services?;
    static func setupShared(){
        shared = Services();
    }
    
}

func SERVICES() -> Services {
    if Services.shared == nil {
        Services.setupShared()
    }
    return Services.shared!;
}

