//
//  BaseVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

enum BottomItemSelect:Int {
    case Periodic = 0
    case Reaction
    case Home
    case AR
    case Setting
}

class BaseVC: UIViewController {
    
    @IBOutlet weak var barBottomItemView: UIView?
    @IBOutlet weak var tabBarTopItemView: UIView?
    @IBOutlet weak var vHeader:CustomNavigationBar?
    
    var buttonItemView: TabBarBottomView?
    var topItemView: TabBarTopView?
    var modeBar: ModeBottomBar = .modeMain
    
    private var gesDismissKeyboardDetector : UITapGestureRecognizer? = nil;
    private var obsKeyboardChangeFrame: NSObjectProtocol? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupBarButtomItemView() {
        self.updateBottomBar()
    }
    
    func updateBottomBar() {
        buttonItemView = TabBarBottomView.load()
        buttonItemView?.delegate = self
        barBottomItemView?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        let barItemHome = BarBottomItem.init(#imageLiteral(resourceName: "ic_Password"), #imageLiteral(resourceName: "ic_Password"), "Home".localized)
        let barItemPeriodic = BarBottomItem.init(#imageLiteral(resourceName: "ic_Periodic"), #imageLiteral(resourceName: "ic_Periodic"), "Periodic".localized)
        let barItemReaction = BarBottomItem.init(#imageLiteral(resourceName: "ic_Reaction"), #imageLiteral(resourceName: "ic_Reaction"), "Reaction".localized)
        let barItemAR = BarBottomItem.init(#imageLiteral(resourceName: "ic_AR"), #imageLiteral(resourceName: "ic_AR"), "AR".localized)
        let barItemSetting = BarBottomItem.init(#imageLiteral(resourceName: "ic_Setting"), #imageLiteral(resourceName: "ic_Setting"), "Setting".localized)
        
        self.buttonItemView?.barButtomItems = [barItemPeriodic, barItemReaction, barItemHome, barItemAR, barItemSetting]
        if let _buttomItemView = self.buttonItemView {
            self.barBottomItemView?.addSubview(_buttomItemView, edge: UIEdgeInsets.zero)
        }
    }
}

extension BaseVC{
    
    final func registerForKeyboardNotifications() {
        
        guard obsKeyboardChangeFrame == nil else {
            return;
        }
        
        obsKeyboardChangeFrame =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main,
                                                   using: keyboardWillChangeFrame(noti:))
    }
    
    final func unregisterForKeyboardNotifications() {
        
        guard let obs = obsKeyboardChangeFrame else {
            return;
        }
        
        obsKeyboardChangeFrame = nil;
        NotificationCenter.default.removeObserver(obs);
    }
    
    final func addDismissKeyboardDetector() {
        
        guard gesDismissKeyboardDetector == nil else {
            return;
        }
        
        gesDismissKeyboardDetector = UITapGestureRecognizer(target: self,
                                                            action: #selector(dismissKeyboard(tapGesture:)));
        
        self.view.addGestureRecognizer(gesDismissKeyboardDetector!);
    }
    
    final func removeDismissKeyboardDetector() {
        
        guard let ges = gesDismissKeyboardDetector else {
            return;
        }
        
        gesDismissKeyboardDetector = nil;
        self.view.removeGestureRecognizer(ges);
    }
    
    func keyboardWillChangeFrame(noti: Notification) {}
    
    @objc func dismissKeyboard(tapGesture: UITapGestureRecognizer?) {
        self.view.endEditing(true);
    }
    
    func getKeyboardHeight(noti:NSNotification) -> CGFloat {
        
        let userInfo:NSDictionary = noti.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        return keyboardHeight;
    }
}

//MARK: - BarButtomItemViewDelegate
extension BaseVC: TabBarBottomViewDelegate {
    @objc func didSelectBarButtomItem(tabbarBottomView: TabBarBottomView, indexBarItem: Int) {
        print("IndexBottomBarItem:\(indexBarItem)")
        let itemSelect =  BottomItemSelect(rawValue: indexBarItem)
        if Caches().currentBarItemSelected != itemSelect{
            self.navigationController?.popViewController(animated: false)
            switch itemSelect! {
            case .Home:
                let vc: HomeVC = HomeVC.load(SB: .Home)
                App().mainVC?.rootNV?.setViewControllers([vc], animated: false)
                
            case .Periodic:
                let vc: PeriodicTableVC = PeriodicTableVC.load(SB: .Periodic)
                App().mainVC?.rootNV?.setViewControllers([vc], animated: false)
                break
            case .Reaction:
                break
            case .AR:
                break
            case .Setting:
//                let vc: ProfileVC = ProfileVC.load(SB: .Profile)
//                vc.userModel = Caches().user
//                App().mainVC?.rootNV?.setViewControllers([vc], animated: false)
                break
            }
        }
        Caches().currentBarItemSelected = itemSelect!
    }
}

//MARK: -Other funtion
extension BaseVC{
    func didSelectback() {
        self.navigationController?.popViewController(animated: true)
    }
}
