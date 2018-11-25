//
//  CategoryModel.swift
//  ChemistryAR
//
//  Created by Admin on 11/15/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class CategoryModel: BaseModel, Codable {
    
    var active: Bool?
    var _id: String?
    var name: String?
    var descr: String?
    var createdAt: String?
    var updatedAt: String?
}
