//
//  BaseVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SpreadsheetView

enum BottomItemSelect: Int {
    case Periodic = 0
    case Reaction
    case Home
    case AR
    case Setting
}

class BaseVC: UIViewController {
    
    @IBOutlet weak var tabBarTopItemView: UIView?
    @IBOutlet weak var vHeader: CustomNavigationBar?
    @IBOutlet weak var vContainer: SpreadsheetView?
    
    var customNV: CustomNavigationBar?
    
    var topItemView: TabBarTopView?
    var modeBar: ModeBottomBar = .modeMain
    
    private var gesDismissKeyboardDetector : UITapGestureRecognizer? = nil;
    private var obsKeyboardChangeFrame: NSObjectProtocol? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printControllerName()
        self.navigationController?.setNavigationBarHidden(checkNavigationBarHidden(), animated: true)
    }
    
    func printControllerName() {
        #if DEBUG
        let name = String(describing: self)
        print("Current Screen is \(name)")
        #endif
    }
    
    
    func checkNavigationBarHidden() -> Bool {
        if self is LoginVC || self is MainVC {
            return true
        }
        return false
    }
    
    func updateCustomNavigationBar(_ barStyle: NavigationBarStyle, _ title: String?) {
        let backBarItem: UIBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(onNavigationBack(_:)))
        let editBarItem: UIBarButtonItem = UIBarButtonItem.editButton(target: self, action: #selector(onNavigationClickRightButton(_:)))
        let saveBarItem: UIBarButtonItem = UIBarButtonItem.saveButton(target: self, action: #selector(onNavigationClickRightButton(_:)))

        if let title = title {
            self.navigationItem.title = title
        }
        switch barStyle {
        case .None:
            break
        case .BackOnly:
            self.navigationItem.leftBarButtonItem = backBarItem
            break
        case .BackEdit:
            self.navigationItem.leftBarButtonItem = backBarItem
            self.navigationItem.rightBarButtonItem = editBarItem
            break
        case .BackDone:
            self.navigationItem.leftBarButtonItem = backBarItem
            self.navigationItem.rightBarButtonItem = saveBarItem
            break
        }
    }
    
    
    @objc func onNavigationBack(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        //
    }
}

extension BaseVC {
    
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
extension BaseVC {
    func didSelectback() {
        self.navigationController?.popViewController(animated: true)
    }
}
