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
    
    var user :UserModel{
        set(newValue){
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                userDefaults.set(encoded, forKey: USER_DEFAULT_KEY.HF_USER)
            }
        }
        get {
            if let data = userDefaults.object(forKey: USER_DEFAULT_KEY.HF_USER) as? Data {
                let decoder = JSONDecoder()
                if let object = try? decoder.decode(UserModel.self, from: data) {
                    return object
                }
            }
            
            return UserModel()
        }
    }
    
    var token:String{
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
        userDefaults.removeObject(forKey: USER_DEFAULT_KEY.HF_TOKEN_USER)
    }
    
    
    func setObject(obj: Any, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: obj)
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
}
