//
//  SolubilityTableVC.swift
//  ChemistryAR
//
//  Created by HHumorous on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class SolubilityTableVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }

}
