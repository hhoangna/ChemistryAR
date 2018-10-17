//
//  BaseNV.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class BaseNV: UINavigationController {
    
    var backgroundImage = UIImage(named: "img_Banner")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage =
            backgroundImage?.resizableImage(
                withCapInsets: UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: (backgroundImage?.size.height)! - 1,
                                            right: (backgroundImage?.size.width)! - 1))
        setupCustomNavigationBar()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupCustomNavigationBar() {
        let navigationBarAppearance = self.navigationBar
        navigationBarAppearance.setBackgroundImage(backgroundImage, for: .default)
        navigationBarAppearance.setBackgroundImage(backgroundImage, for: .compact)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseNV:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count > 1 {
            return true
        }
        return false
    }
}
