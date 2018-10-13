//
//  MainVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ESTabBarController_swift


class MainVC: BaseVC,UITabBarControllerDelegate {
    
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
        let vc  = setupESTabBarController()
        
        rootNV?.pushViewController(vc, animated: false)
    }
    
    func setupESTabBarController() -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = self
        
        let vHome:HomeVC = HomeVC.load(SB: .Home)
        let vPeriodic:PeriodicTableVC = PeriodicTableVC.load(SB: .Periodic)
        let vReaction:ReactionVC = ReactionVC.load(SB: .Reaction)
        let vARKit:ARKitVC = ARKitVC.load(SB: .AR)
        let vSetting:SettingVC = SettingVC.load(SB: .Setting)
        
        vHome.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        vPeriodic.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        vReaction.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        vARKit.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        vSetting.tabBarItem = ESTabBarItem.init(BounceCustomTabbar(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [vHome, vPeriodic, vReaction, vARKit, vSetting]
        
        return tabBarController
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
