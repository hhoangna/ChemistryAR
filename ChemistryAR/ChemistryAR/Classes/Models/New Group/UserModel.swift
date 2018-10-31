//
//  UserModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ObjectMapper

class User: BaseModel {
    var name: String?
    var email: String?
    var birthday: Double?
    var address: String?
    var password: String?
    var _id: String?
    var imgLink: String?
    var role: String?
    var isVIP: Bool?
    var createAt: Double?
    var lastActive: Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        _id <- map["_id"]
        name <- map["name"]
        email <- map["email"]
        address <- map["address"]
        password <- map["password"]
        imgLink <- map["imgLink"]
        role <- map["role"]
        isVIP <- map["isVIP"]
        birthday <- map["birthday"]
        createAt <- map["createAt"]
        lastActive <- map["lastActive"]
    }
}

class UserModel: BaseModel {
    var user: User?
    var token: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        token <- map["token"]
        user <- map["user"]
    }
}
