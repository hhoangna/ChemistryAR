//
//  ElementTableVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/17/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementTableVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateCustomNavigationBar(.BackOnly, "Something")
        
    }
}

extension ElementTableVC: CustomNavigationBarDelegate {
    func didSelectBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectRight() {
        //
    }
    
    
}
