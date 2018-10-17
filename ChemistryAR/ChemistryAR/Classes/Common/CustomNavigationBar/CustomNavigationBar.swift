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
}

protocol CustomNavigationBarDelegate: class {
    func didSelectBack()
    func didSelectRight()
}

class CustomNavigationBar: BaseNV {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(false, animated: true)
    }
}

extension BaseVC {
    
    func updateCustomNavigationBar(_ barStyle: NavigationBarStyle, _ title: String?) {
        
        if let title = title {
            self.navigationItem.title = title
        }
        switch barStyle {
        case .None:
            self.navigationItem.leftBarButtonItem = menuBarItem
            break
        case .BackOnly:
            self.navigationItem.leftBarButtonItem = backBarItem
            break
        }
    }
    
    @objc func onNavigationBack(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        if let navi = self.navigationController {
            
            if (navi.viewControllers.count <= 1) {
                if (navi.presentingViewController != nil) {
                    navi.dismiss(animated: true, completion: nil)
                }
            }else {
                navi.popViewController(animated: true);
            }
            
        }else {
            if (self.presentingViewController != nil) {
                self.dismiss(animated: true, completion: nil);
            }
        }
    }
    
    @objc func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        delegate?.didSelectedRightButton()
    }
}
