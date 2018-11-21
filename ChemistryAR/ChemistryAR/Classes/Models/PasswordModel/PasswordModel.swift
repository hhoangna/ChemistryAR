//
//  PasswordModel.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class PasswordModel: BaseModel, Codable {
    var oldPassword: String?
    var newPassword: String?
    
    override func getDataObject() -> Data {
        return EncodeModel(model: self);
    }
}
