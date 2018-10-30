//
//  Cache.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ObjectMapper

class Cache: NSObject {
    static let shared = Cache()
    private let userDefaults = UserDefaults.standard
    private var userLogin: UserModel?
    
    /*
    var user: User {
        set (newValue) {
            if let encoder = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) {
                    userDefaults.set(encoder, forKey: USER_DEFAULT_KEY.HF_USER)
            }
        }
        get {
            if let data = userDefaults.object(forKey: USER_DEFAULT_KEY.HF_USER) as? Data {
                if let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! User {
                    return object
                }
            }
            
            return User()
        }
    }
    */
    
    var user: User? {
        get {
            return getUser()
        }
    }

    var token: String{
        set{
            userDefaults.set(newValue, forKey: USER_DEFAULT_KEY.HF_TOKEN_USER)
        }
        
        get{
            if let data = userDefaults.object(forKey: USER_DEFAULT_KEY.HF_TOKEN_USER) as? String {
                return data
            }
            return ""
        }
    }
    
    var hasLogin:Bool {
        get{
            return token.length > 0
        }
    }
    
    func removeAllCache() {
        userDefaults.removeObject(forKey: USER_DEFAULT_KEY.HF_TOKEN_USER)
        userDefaults.removeObject(forKey: USER_DEFAULT_KEY.HF_USER)
    }
    
    
    func setObject(obj: Any, forKey key: String) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
        userDefaults.set(data, forKey: key)
        userDefaults.synchronize()
    }
    
    func getObject(forKey key: String) -> Any? {
        
        if let data = userDefaults.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
            
        } else {
            return nil
        }
    }
    
    func getTokenFCM() -> String?{
        return getObject(forKey:USER_DEFAULT_KEY.HF_FCM_TOKEN) as? String
    }
    
    func getTokenDevice() -> String?{
        return getObject(forKey:USER_DEFAULT_KEY.HF_DEVICE_TOKEN) as? String
    }
    
    func setUser(_ user: User?) {
        if (user != nil) {
            let data = user?.getJSONString()
            if (data != nil) {
                userDefaults.set(data, forKey: USER_DEFAULT_KEY.HF_USER)
            } else {
                //
            }
        } else {
            userDefaults.removeObject(forKey: USER_DEFAULT_KEY.HF_USER)
        }
        
        userDefaults.synchronize()
    }
    
    private func getUser() -> User? {
        
        var user: User?
        if(user !=  nil) {
            user = self.user
        }else {
            let data = userDefaults.object(forKey: USER_DEFAULT_KEY.HF_USER)
            if(data != nil) {
                user =  User(JSON: data as! [String:Any])
            }
        }
        
        return user;
    }
}
