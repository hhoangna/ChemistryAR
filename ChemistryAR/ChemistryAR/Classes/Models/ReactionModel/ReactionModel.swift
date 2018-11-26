//
//  ReactionModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ReactionDetailModel: BaseModel, Codable {

    var phuong_trinh: String? = ""
    var dieu_kien: String? = ""
    //var bookmark_active: String?
    var id: String? = ""
}

class ReactionModel: BaseModel, Codable {
    
    var equation: [ReactionDetailModel]?
    var show_pagination: String? = ""
    var count_equations: Int?
    var result_number: Int?
    var links: String?
    var input_taothanh: String?
    var input_thamgia: String?
}
