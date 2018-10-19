//
//  ElementModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementModel: BaseModel, Codable {
    
    var _id: String?
    var name: String?
    var mass: String?
    var symbol: String?
    var type: String?
    var image: String?
    var atom: Int?
    var electronicConfiguration: String?
    var electronegativity: String?
    var oxidationStates: [Int?]
    
    func getNewElement() -> ResponseDictionary {
        let body = NSMutableDictionary()
        
        body.setValue(name, forKey: "name")
        body.setValue(mass, forKey: "mass")
        body.setValue(symbol, forKey: "symbol")
        body.setValue(type, forKey: "type")
        body.setValue(atom, forKey: "atom")
        body.setValue(image, forKey: "image")
        body.setValue(electronegativity, forKey: "electronegativity")
        body.setValue(electronicConfiguration, forKey: "electronicConfiguration")
        body.setValue(oxidationStates, forKey: "oxidationStates")
        
        return body as! ResponseDictionary
    }
}
