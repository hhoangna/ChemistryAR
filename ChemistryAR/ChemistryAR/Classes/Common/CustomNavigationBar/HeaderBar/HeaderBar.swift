//
//  HeaderBar.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

protocol HeaderBarDelegate {
    func onPressBtnBack(view:HeaderBar,btn:UIButton)
    func onPressBtnOne(view:HeaderBar,btn:UIButton)
    func onPressBtnCreate(view:HeaderBar,btn:UIButton)
    func onPressBtnTwo(view:HeaderBar,btn:UIButton)
}

class HeaderBar: UIView {

    @IBOutlet weak var imvLogo:UIImageView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var btnBack:UIButton?
    @IBOutlet weak var btnOne:UIButton?
    @IBOutlet weak var btnTwo:UIButton?
    @IBOutlet weak var btnAdd:UIButton?
    
    var delegate: HeaderBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func hiddenAllButton() {
        btnBack?.isHidden = true
        btnOne?.isHidden = true
        btnTwo?.isHidden = true
    }
    
    @IBAction func onbtnClickBack(btn:UIButton){
        delegate?.onPressBtnBack(view: self, btn: btn)
    }
    
    @IBAction func onbtnClickCreate(btn:UIButton){
        delegate?.onPressBtnCreate(view: self, btn: btn)
    }
    
    @IBAction func onbtnClickOne(btn:UIButton){
        delegate?.onPressBtnOne(view: self, btn: btn)
    }
    
    @IBAction func onbtnClickTwo(btn:UIButton){
        delegate?.onPressBtnTwo(view: self, btn: btn)
    }

}
