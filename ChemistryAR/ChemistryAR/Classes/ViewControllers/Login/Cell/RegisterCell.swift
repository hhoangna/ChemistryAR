//
//  RegisterCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class RegisterCell: BaseClvCell {
    
    @IBOutlet fileprivate weak var tfUsername: UITextField!
    @IBOutlet fileprivate weak var tfEmail: UITextField!
    @IBOutlet fileprivate weak var tfPassword: UITextField!
    @IBOutlet fileprivate weak var tfRePassword: UITextField!
    @IBOutlet fileprivate weak var viewResgister: UIView?
    @IBOutlet fileprivate weak var btnResgister: UIButton?
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != self.tfUsername {
                self.tfUsername?.resignFirstResponder()
            }
            
            if touch.view != self.tfEmail {
                self.tfEmail?.resignFirstResponder()
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
        var isValidateEmail:Bool = false
        var isValidateConfirmPassword:Bool = false
        var isValidatePassword:Bool = false
        var isValidateUserName:Bool = false
    }
    
    var isValidateRegister:ValidateRegister = ValidateRegister()
    var isCheckEnableButtonRegister:Bool = false {
        didSet {
            checkEnableCreateProfile()
        }
    }
    
    func initUI() {
        setUpTextField()
        setUpViewResgister()
        setUpButtonResgister()
    }
    
    func setUpTextField() {
        tfPassword.delegate = self;
        tfUsername.delegate = self;
        tfEmail.delegate = self;
        tfRePassword.delegate = self;
        tfPassword.isSecureTextEntry = true;
        tfRePassword.isSecureTextEntry = true;
    }
    
    func setTextUserName(userName:String) {
        tfUsername.text = userName
    }
    
    func setTextEmail(email:String) {
        tfEmail.text = email
    }
    
    func setTextPassword(password:String) {
        tfPassword.text = password
    }
    
    func setTextRePassword(rePassword:String) {
        tfRePassword.text = rePassword
    }
    
    func setUpViewResgister() {
        viewResgister?.setRoudary(radius: 4.0);
    }
    
    func setUpButtonResgister()  {
        btnResgister?.setRoudary(radius: 4.0);
        isCheckEnableButtonRegister = false;
    }
    
    func checkEnableCreateProfile(){
        btnResgister?.isEnabled = isCheckEnableButtonRegister
        btnResgister?.alpha = isCheckEnableButtonRegister ? 1 : 0.5
    }
    
    func validateRegister()->Bool{
        var isRegister:Bool = false
        guard isValidateRegister.isValidateEmail,
            isValidateRegister.isValidatePassword,
            isValidateRegister.isValidateConfirmPassword,
            isValidateRegister.isValidateUserName,
            isValidateRegister.isValidateEmail
            else {
                return isRegister
        }
        isRegister = true
        return isRegister
    }
    
    func performLocalValidateUserName(){
        if (tfUsername.text?.isEmpty)!{
            isValidateRegister.isValidateUserName = false
        }else{
            isValidateRegister.isValidateUserName = true
        }
    }
    
    func performLocalValidateEmail(){
        
        let isEmail = ValidateUtils.validateEmail(tfEmail.text ?? "");
        if ((tfEmail.text?.isEmpty)! || isEmail == false){
            tfEmail.textColor = .red
            isValidateRegister.isValidateEmail = false
        }else{
            tfEmail.textColor = .black
            isValidateRegister.isValidateEmail = true
        }
    }
    
    
    func performLocalValidatePassword(){
        if (tfPassword.text?.isEmpty)!{
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

extension RegisterCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        switch textField {
        case tfUsername:
            performLocalValidateUserName()
            break
        case tfEmail:
            performLocalValidateEmail()
            break
        case tfPassword:
            performLocalValidatePassword()
            break
        case tfRePassword:
            performLocalValidateConfirmPassword(rePass: updatedString)
            break
        default:
            print("ok")
        }
        
        isCheckEnableButtonRegister = validateRegister()
        return true
    }
}

extension RegisterCell {
    @IBAction func onBtnRegisterPressed(_ sender: UIButton) {
        signup()
    }
}

extension RegisterCell {
    func signup() {
        let signup = SignupModel()
        signup.email = tfEmail?.text
        signup.password = tfPassword?.text
        signup.name = tfUsername?.text
        
        App().showLoadingIndicator()
        SERVICES().API.signup(signupModel: signup) {[weak self] (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object:
                self?.rootVC?.showAlertView(E("Create Successfully!"))
            case .error(let error):
                self?.rootVC?.showAlertView(E(error.message))
                break;
            }
        }
    }
}
