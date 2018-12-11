//
//  LoginModel.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class LoginModel: BaseModel, Codable {
    
    var email:String?
    var password:String?
    var deviceAPNSToken:String?
    var deviceFcmToken:String?
    
    override func getDataObject() -> Data {
        return EncodeModel(model: self);
    }
}
