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
    
    @IBOutlet weak var vContainerMaster:UIView?
    var barController:ESTabBarController?
    override func viewDidLoad() {
        super.viewDidLoad()
        pushHomeViewController()
    }
    

    func pushHomeViewController() {
        let vc  = setupESTabBarController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func setupESTabBarController() -> ESTabBarController {
        let tabBar = ESTabBarController()
        tabBar.delegate = self
        tabBar.navigationItem.hidesBackButton = true
        barController = tabBar
        
        let vPeriodic:PeriodicTableVC = PeriodicTableVC.load(SB: .Periodic)
        let vReaction:ReactionVC = ReactionVC.load(SB: .Reaction)
        let vARKit:ARKitVC = ARKitVC.load(SB: .AR)
        let vSetting:SettingVC = SettingVC.load(SB: .Setting)
        
        vPeriodic.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Periodic Table", image: UIImage(named: "ic_table"), selectedImage: UIImage(named: "ic_tableSelected"))
        vReaction.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Reaction Chemical", image: UIImage(named: "ic_react"), selectedImage: UIImage(named: "ic_reactSelected"))
        vARKit.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Augmented Reality", image: UIImage(named: "ic_AR"), selectedImage: UIImage(named: "ic_arSelected"))
        vSetting.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Setting", image: UIImage(named: "ic_set"), selectedImage: UIImage(named: "ic_setSelected"))
        
        tabBar.viewControllers = [vPeriodic, vReaction, vARKit, vSetting]
        
        return tabBar
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is  PeriodicTableVC {
            tabBarController.navigationItem.title = "Periodic Table"
            
        }else if viewController is ReactionVC{
            tabBarController.navigationItem.title = "Reaction Chemical"

        }else if viewController is ARKitVC{
            tabBarController.navigationItem.title = "Augmented Reality"

        }else if viewController is SettingVC{
            tabBarController.navigationItem.title = "Setting"
        }
    }
}
