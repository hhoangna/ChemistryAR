//
//  ProfileCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate: class {
    func didSelectBtnRight(cell: ProfileCell, btn: UIButton)
}

class ProfileCell: BaseTbvCell {
    
    @IBOutlet weak var csButtonWidth: NSLayoutConstraint?
    @IBOutlet weak var imgVip: UIImageView?
    
    var delegate: ProfileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onBtnRightPressed(_ sender: UIButton) {
        delegate?.didSelectBtnRight(cell: self, btn: sender)
    }
}
