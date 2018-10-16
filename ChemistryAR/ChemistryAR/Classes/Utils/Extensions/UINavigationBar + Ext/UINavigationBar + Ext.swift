//
//  UINavigationBar + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/16/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func clearNavigationBar() {
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: .default)
        self.backgroundColor = .clear
    }
}
