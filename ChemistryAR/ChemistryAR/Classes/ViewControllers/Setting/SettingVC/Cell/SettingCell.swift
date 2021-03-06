//
//  SettingCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class SettingCell: BaseTbvCell {
    
    @IBOutlet weak var imgAvatar: UIImageView?
    @IBOutlet weak var imgVip: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgAvatar?.layer.cornerRadius = (imgAvatar?.frame.size.height)! / 2
        imgAvatar?.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
