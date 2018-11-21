//
//  TextViewInput.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

protocol TextViewInputDelegate:class {
    func textViewDidChange(_ textView:UITextView)
}

class TextViewInput: UIView {
    
    @IBOutlet weak var lblPlaceholder:UILabel?
    @IBOutlet weak var tvContent:UITextView?
    
    weak var delegate:TextViewInputDelegate?
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvContent?.delegate = self
        lblPlaceholder?.font = AppFont.helveticaRegular(with: 14)
        self.frame.size = CGSize(width: self.frame.size.width, height: 80)
    }
    
}
extension TextViewInput:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceholder?.isHidden = !isEmpty(textView.text)
        self.frame.size = (tvContent?.contentSize)!
        delegate?.textViewDidChange(textView)
    }
}
