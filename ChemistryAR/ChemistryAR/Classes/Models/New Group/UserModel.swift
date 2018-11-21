//
//  UserModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class UserModel: BaseModel, Codable {
    
    var _id: String?
    var name: String?
    var email: String?
    var birthday: Date?
    var address: String?
    var password: String?
    var active: Bool?
    var role: String?
    var avatar: String?
    var lastActive: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var dateOffline: Int?
    
    func bodyUpdate() -> ResponseDictionary {
        let body = NSMutableDictionary()
        body.setValue(E(name), forKey: "name")
        body.setValue(E(address), forKey: "address")
        if let _dob = birthday {
            let dob = ServerDateFormater.string(from: _dob)
            body.setValue(dob, forKey: "birthday")
        }
        body.setValue(avatar, forKey: "avatar")
        
        return body as! ResponseDictionary
    }
    
}
