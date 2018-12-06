//
//  AboutVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/29/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class AboutVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateCustomNavigationBar(.BackOnly, "About")
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        didSelectback()
    }
}
