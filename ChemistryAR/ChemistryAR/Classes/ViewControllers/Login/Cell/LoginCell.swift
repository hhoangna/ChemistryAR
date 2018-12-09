//
//  LoginCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginCell: BaseClvCell {
    @IBOutlet fileprivate weak var tfUsername: UITextField?
    @IBOutlet fileprivate weak var tfPassword: UITextField?
    @IBOutlet fileprivate weak var viewLogin: UIView?
    @IBOutlet fileprivate weak var btnLogin: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfUsername?.keyboardType = .emailAddress
        tfUsername?.returnKeyType = .next
        tfPassword?.returnKeyType = .go
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != self.tfUsername {
                self.tfUsername?.resignFirstResponder()
            }
            
            if touch.view != self.tfPassword {
                self.tfPassword?.resignFirstResponder()
            }
        }
    }
    
    func checkForValidate() -> Bool {
        if let email = tfUsername?.text {
            if !(ValidateUtils.validateEmail(email)) {
                tfUsername?.becomeFirstResponder()
                self.rootVC?.showAlertView("Email invalid".localized)
                return false
            }
        }
        
        if let pass = tfPassword?.text {
            if !(ValidateUtils.validatePassword(pass)) {
                tfPassword?.becomeFirstResponder()
                self.rootVC?.showAlertView("Password invalid".localized)
                return false
            }
        }
        
        return true
    }
    
    @IBAction func onbtnClickLogin(button: UIButton) {
        login()
    }
}

extension LoginCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tfUsername == textField {
            tfPassword?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if checkForValidate() {
                login()
            }
        }
        return false
    }
}

extension LoginCell {
    func login() {
        let login = LoginModel()
        login.email = tfUsername?.text
        login.password = tfPassword?.text
        App().onLoginSuccess()

        App().showLoadingIndicator()
        SERVICES().API.login(loginModel: login) {[weak self] (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                if let user = obj.user{
                    Caches().user = user
                }
                Caches().token = E(obj.token)
                App().onLoginSuccess()
                
                break;
            case .error(let error):
                self?.rootVC?.showAlertView(E(error.message))
                break;
            }
        }
    }
}
