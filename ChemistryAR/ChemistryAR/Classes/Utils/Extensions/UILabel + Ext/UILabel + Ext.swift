//
//  UILabel + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 11/27/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//
import UIKit

extension UILabel{
    
    // MARK: - IBInspectable
    @IBInspectable var localizeKey: String {
        
        get {
            return ""
        } set {
            self.text = newValue.localized
        }
    }
}

