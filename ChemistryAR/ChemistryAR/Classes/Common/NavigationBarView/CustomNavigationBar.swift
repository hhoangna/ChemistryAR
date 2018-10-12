//
//  CustomNavigationBar.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

protocol CustomNavigationBarDelegate: class {
    func didSelectback(header: CustomNavigationBar , btn:UIButton);
    func didSelectOne(header: CustomNavigationBar , btn:UIButton);
    func didSelecCreate(header: CustomNavigationBar , btn:UIButton);
    func diSelectBtnTwo(header: CustomNavigationBar , btn:UIButton);
}

class CustomNavigationBar: UIView {
    
    enum NavigationBarStyle {
        case None
        case BackOnly
    }

    var vHeaderBar: HeaderBar?
    weak var delegate: CustomNavigationBarDelegate?
    var strTitle: String?
    var originType: NavigationBarStyle = .None
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        
        if vHeaderBar == nil {
            vHeaderBar = .load(nib: "HeaderBar", owner: nil)
            vHeaderBar?.delegate = self
            vHeaderBar?.translatesAutoresizingMaskIntoConstraints = false;
            if let _vHeaderBar = vHeaderBar{
                self.addSubview(_vHeaderBar, edge: .zero)
                vHeaderBar?.addConstaints(top: 0, right: 0, bottom: 0, left: 0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func setCustomNavigationBar(type:NavigationBarStyle, title:String) {
        strTitle = title;
        originType  = type
        self.updateUIWithType(type: type)
    }
    
    func updateUIWithType(type:NavigationBarStyle) {
        vHeaderBar?.hiddenAllButton()
        vHeaderBar?.lblTitle?.text = strTitle;
        vHeaderBar?.lblTitle?.isHidden = false
        
        switch type {
        case .None:
            vHeaderBar?.hiddenAllButton()
        case .BackOnly:
            vHeaderBar?.btnBack?.isHidden = false
        default:
            break
        }
    }
}

extension CustomNavigationBar: HeaderBarDelegate {
    func onPressBtnCreate(view: HeaderBar, btn: UIButton) {
        delegate?.didSelecCreate(header: self, btn: btn)
    }
    
    func onPressBtnBack(view: HeaderBar, btn: UIButton) {
        delegate?.didSelectback(header: self, btn: btn)
    }
    
    func onPressBtnOne(view: HeaderBar, btn: UIButton) {
        delegate?.didSelectOne(header: self, btn: btn)
    }
    
    func onPressBtnTwo(view: HeaderBar, btn: UIButton) {
        delegate?.diSelectBtnTwo(header: self, btn: btn)
    }
}

