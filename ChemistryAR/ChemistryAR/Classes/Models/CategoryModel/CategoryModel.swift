//
//  CategoryModel.swift
//  ChemistryAR
//
//  Created by Admin on 11/15/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class CategoryModel: BaseModel, Codable {
    
    var _id: String?
    var active: Bool?
    var name: String?
    var descr: String?
    var createdAt: Date?
    var updatedAt: Date?
}
