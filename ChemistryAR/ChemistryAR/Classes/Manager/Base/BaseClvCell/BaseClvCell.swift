//
//  BaseClvCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class BaseClvCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblSubtitle: UILabel?
    @IBOutlet weak var lblSubtitle1: UILabel?
    @IBOutlet weak var lblSubtitle2: UILabel?
    @IBOutlet weak var lblSubtitle3: UILabel?
    
    @IBOutlet weak var lineView: UIView?
    @IBOutlet weak var lineView1: UIView?
    @IBOutlet weak var vContent: UIView?
    
    @IBOutlet weak var btnEdit: UIButton?
    @IBOutlet weak var btnDelete: UIButton?
    
    @IBOutlet weak var imgIcon: UIImageView?
}
