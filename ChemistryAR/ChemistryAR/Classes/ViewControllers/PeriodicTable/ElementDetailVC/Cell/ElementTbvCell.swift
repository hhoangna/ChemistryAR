//
//  ElementTbvCell.swift
//  ChemistryAR
//
//  Created by Admin on 11/26/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementTbvCell: BaseTbvCell {
    
    @IBOutlet weak var tvContent: UITextView?
    @IBOutlet weak var imgBanner: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
