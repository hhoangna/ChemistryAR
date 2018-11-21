//
//  CustomNavigationBar.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

enum NavigationBarStyle {
    case None
    case BackOnly
    case BackEdit
    case BackDone
}


class CustomNavigationBar: BaseNV {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(false, animated: true)
    }
}
