//
//  ElementModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementModel: BaseModel, Codable {

    var oxidationStates: [Int]?
    var active: Bool?
    var _id: String?
    var name: String?
    var atomicMass: Double?
    var boilingPoint: Double?
    var density: Double?
    var meltingPoint: Double?
    var atomicNumber: Int?
    var standardState: String?
    var source: String?
    var imagePreview: String?
    var summary: String?
    var symbol: String?
    var electronicConfiguration: String?
    var xpos: Int?
    var ypos: Int?
    var category: CategoryModel
    var createdAt: String?
    var updatedAt: String?
    
    func getOxitdation() -> String {
        var oxitdation = ""
        if oxidationStates?.count ?? 0 == 1 {
            oxitdation = String(format: "%@", oxidationStates?.first?.formattedWithSeparator ?? "")
            return oxitdation
        } else if oxidationStates?.count ?? 0 > 1 {
            oxidationStates?.forEach {
                if $0 != oxidationStates?.last {
                    oxitdation = oxitdation + String(format: "%@, ", $0.formattedWithSeparator)
                } else {
                    oxitdation = oxitdation + String(format: "%@", $0.formattedWithSeparator)
                }
            }
            return oxitdation
        } else {
            return oxitdation
        }
    }
    
    var colorCategory: UIColor {
        get {
            let id = category._id
            switch id {
            case "5bed67c2aba1d2fa60e0240c": //Khi hiem
                return AppColor.khihiemColor
            case "5bed67c2aba1d2fa60e02411": //Actitni
                return AppColor.actiniColor
            case "5bed67c2aba1d2fa60e02410": //Lantan
                return AppColor.lantanColor
            case "5bed67c2aba1d2fa60e02413": //A kim
                return AppColor.akimColor
            case "5bed67c2aba1d2fa60e02415": //Unknown
                return AppColor.unknownColor
            case "5bed67c2aba1d2fa60e0240b": //Halogen
                return AppColor.halogenColor
            case "5bed67c2aba1d2fa60e0240d":
                return AppColor.kiemColor
            case "5bed67c2aba1d2fa60e0240e"://Kiem tho
                return AppColor.kiemthoColor
            case "5bed67c2aba1d2fa60e0240f":
                return AppColor.chuyentiepColor //Chuyen tiep
            case "5bed67c2aba1d2fa60e02412":
                return AppColor.klyeuColor
            default:
                return AppColor.phikimColor
            }
        }
    }
    
    var colorStates: UIColor {
        get {
            switch standardState {
            case "Gas":
                return AppColor.gasColor
            case "Solid":
                return AppColor.black
            case "Liquid":
                return AppColor.mainColor
            default:
                return AppColor.borderColor
            }
        }
    }
}

class FilterElementModel: BaseModel, Codable {
    var text: String?
    var category: CategoryModel?
    
    func bodyFilter() -> ResponseDictionary {
        let body = NSMutableDictionary()
        body.setValue(E(text), forKey: "text")
        
        return body as! ResponseDictionary
    }
}
