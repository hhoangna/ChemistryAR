
//
//  RoundedButton.swift
//  ChemistryAR
//
//  Created by Admin on 11/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = AppColor.blueColor
        layer.cornerRadius = 8
        clipsToBounds = true
        setTitleColor(.white, for: [])
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? AppColor.blueColor : AppColor.grayColor
        }
    }
    
    var toggledOn: Bool = true {
        didSet {
            if !isEnabled {
                backgroundColor = AppColor.grayColor
                return
            }
            backgroundColor = toggledOn ? AppColor.blueColor : AppColor.lightBlueColor
        }
    }
}
