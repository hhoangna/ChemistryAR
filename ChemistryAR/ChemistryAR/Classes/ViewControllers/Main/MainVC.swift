//
//  MainVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ESTabBarController_swift


class MainVC: BaseVC, UITabBarControllerDelegate {
    
    @IBOutlet weak var bannerView:UIView?
    @IBOutlet weak var vContainerMaster:UIView?
    
    var rootNV:CustomNavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushHomeViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Main_NV" {
            rootNV = segue.destination as? CustomNavigationBar
        }
    }
    
    func pushHomeViewController() {
        let vc  = setupESTabBarController()
        
        vc.navigationItem.title = "Chemistry AR"
        
        rootNV?.pushViewController(vc, animated: false)
    }
    
    func setupESTabBarController() -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = self
        
        let vPeriodic:PeriodicTableVC = PeriodicTableVC.load(SB: .Periodic)
        let vReaction:ReactionVC = ReactionVC.load(SB: .Reaction)
        let vARKit:ARKitVC = ARKitVC.load(SB: .AR)
        let vSetting:SettingVC = SettingVC.load(SB: .Setting)
        
        vPeriodic.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Periodic Table", image: UIImage(named: "ic_table"), selectedImage: UIImage(named: "ic_tableSelected"))
        vReaction.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Reaction Chemical", image: UIImage(named: "ic_react"), selectedImage: UIImage(named: "ic_reactSelected"))
        vARKit.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Augmented Reality", image: UIImage(named: "ic_AR"), selectedImage: UIImage(named: "ic_arSelected"))
        vSetting.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Setting", image: UIImage(named: "ic_set"), selectedImage: UIImage(named: "ic_setSelected"))
        
        tabBarController.viewControllers = [vPeriodic, vReaction, vARKit, vSetting]
        
        return tabBarController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
