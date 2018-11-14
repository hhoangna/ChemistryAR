//
//  UserModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class UserModel: BaseModel, Codable {
    
    var name: String?
    var email: String?
    var birthday: Double?
    var address: String?
    var password: String?
    var active: Bool?
    var role: String?
    var avatar: JSONValue<FileModel>?
    var lastActive: Date?
    
}
