//
//  MainVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class MainVC: BaseVC {
    
    @IBOutlet weak var bannerView:UIView?
    @IBOutlet weak var vContainerMaster:UIView?
    
    var rootNV:BaseNV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateUI()
        pushHomeViewController()
    }
    
    func updateUI() {
        setupBarButtomItemView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Main_NV" {
            rootNV = segue.destination as? BaseNV
        }
    }
    
    func pushHomeViewController() {
        let vc:HomeVC  = .load(SB: .Home)
        rootNV?.pushViewController(vc, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
