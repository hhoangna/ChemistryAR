
//
//  UIButton + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension UIButton {
    
    // MARK: - IBInspectable
    @IBInspectable var localizeKey: String {
        get {
            return ""
        } set {
            self.setTitle(newValue.localized, for: .normal)
        }
    }
    
    // MARK: - Util properties
    var title: String? {
        get {
            return title(for: .normal);
        }
        set {
            setTitle(newValue, for: .normal);
        }
    }
    
    var titleColor: UIColor? {
        get {
            return titleColor(for: .normal);
        }
        set {
            setTitleColor(newValue, for: .normal);
        }
    }
    
    var attrTitle: NSAttributedString? {
        get {
            return attributedTitle(for: .normal);
        }
        set {
            setAttributedTitle(newValue, for: .normal);
        }
    }
    
    var image: UIImage? {
        get {
            return image(for: .normal);
        }
        set {
            setImage(newValue, for: .normal);
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .normal);
        }
        set {
            setBackgroundImage(newValue, for: .normal);
        }
    }
}
