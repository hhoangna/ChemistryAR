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
    var atomicMass: Double?
    var symbol: String?
    var category: CategoryModel?
    var imagePreview: String?
    var atomicNumber: Int?
    var electronicConfiguration: String?
    var oxidationStates: [Int]?
    var active: Bool?
    var boilingPoint: Double?
    var density: Double?
    var meltingPoint: Double?
    var standardState: String?
    var source: String?
    var summary: String?
    var xpos: Int
    var ypos: Int
    var updatedAt: Date?
    var createdAt: Date?
}
