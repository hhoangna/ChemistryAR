//
//  ChangePassVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ChangePassVC: BaseVC {

    @IBOutlet fileprivate weak var tfOldPass: UITextField!
    @IBOutlet fileprivate weak var tfPassword: UITextField!
    @IBOutlet fileprivate weak var tfRePassword: UITextField!
    @IBOutlet fileprivate weak var btnSave: UIButton?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != self.tfOldPass {
                self.tfOldPass?.resignFirstResponder()
            }
            
            if touch.view != self.tfRePassword {
                self.tfRePassword?.resignFirstResponder()
            }
            
            if touch.view != self.tfPassword {
                self.tfPassword?.resignFirstResponder()
            }
        }
    }
    
    struct ValidateRegister {
        var isValidateConfirmPassword:Bool = false
        var isValidatePassword:Bool = false
    }
    
    var isValidateRegister:ValidateRegister = ValidateRegister(){
        didSet {
            checkEnableCreateProfile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkEnableCreateProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCustomNavigationBar(.BackOnly, "Change Password".localized)
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        didSelectback()
    }
    
    func checkEnableCreateProfile(){
        btnSave?.isEnabled =   isValidateRegister.isValidateConfirmPassword &&
            isValidateRegister.isValidatePassword
        btnSave?.alpha =  btnSave?.isEnabled ?? true ? 1 : 0.5
    }
    
    func performLocalValidatePassword(){
        if ((tfPassword.text?.isEmpty)! || (tfOldPass.text?.isEmpty)!){
            isValidateRegister.isValidatePassword = false
        }else{
            isValidateRegister.isValidatePassword = true
        }
    }
    
    func performLocalValidateConfirmPassword(rePass:String?){
        if (rePass?.isEmpty)! ||
            rePass != tfPassword.text{
            tfRePassword.textColor = .red;
            isValidateRegister.isValidateConfirmPassword = false
        }else{
            tfRePassword.textColor = .black;
            isValidateRegister.isValidateConfirmPassword = true
        }
    }
    
}

extension ChangePassVC{
    
    @IBAction func onbtnClickRegister(btn:UIButton) {
        
        let password = PasswordModel()
        password.oldPassword = tfOldPass?.text
        password.newPassword = tfPassword?.text
        
        App().showLoadingIndicator()
        SERVICES().API.changePassword(model: password) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(_ ):
                self.showAlertView("Your password have been changed!\nPlease Re-Login with new password!", positiveTitle: "OK", positiveAction: { (ok) in
                    App().onReLogin()
                })
            case .error(_ ):
                self.showAlertView("Your password incorrect".localized)
            }
        }
    }
}

extension ChangePassVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfOldPass {
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfRePassword.becomeFirstResponder()
        } else {
            tfRePassword.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        switch textField {
        case tfOldPass:
            performLocalValidatePassword()
        case tfPassword:
            performLocalValidatePassword()
        case tfRePassword:
            performLocalValidateConfirmPassword(rePass: updatedString)
        default:
            print("ok")
        }
        
        return true
    }
}
