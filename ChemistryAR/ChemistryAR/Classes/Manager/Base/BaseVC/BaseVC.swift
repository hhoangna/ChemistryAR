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
    
    @IBOutlet weak var tabBarTopItemView: UIView?
    @IBOutlet weak var vHeader:CustomNavigationBar?
    
    var topItemView: TabBarTopView?
    var modeBar: ModeBottomBar = .modeMain
    
    private var gesDismissKeyboardDetector : UITapGestureRecognizer? = nil;
    private var obsKeyboardChangeFrame: NSObjectProtocol? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = self.navigationController {
            navController.navigationBar.clearNavigationBar()
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

//MARK: -Other funtion
extension BaseVC{
    func didSelectback() {
        self.navigationController?.popViewController(animated: true)
    }
}
