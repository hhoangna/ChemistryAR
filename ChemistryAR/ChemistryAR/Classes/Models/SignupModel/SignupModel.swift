
//
//  SignupModel.swift
//  ChemistryAR
//
//  Created by Admin on 11/15/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class SignupModel: BaseModel, Codable {
    
    var email:String?
    var password:String?
    var name: String?
    
    override func getDataObject() -> Data {
        return EncodeModel(model: self);
    }
}
