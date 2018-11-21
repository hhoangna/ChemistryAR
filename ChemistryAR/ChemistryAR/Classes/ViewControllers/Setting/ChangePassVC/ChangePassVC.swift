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
        var isValidateEmail:Bool = false
        var isValidateConfirmPassword:Bool = false
        var isValidatePassword:Bool = false
    }
    
    
    var isValidateRegister:ValidateRegister = ValidateRegister()
    var isCheckEnableButtonRegister:Bool = false {
        didSet {
            checkEnableCreateProfile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCustomNavigationBar(.BackOnly, "Change Password")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        setUpTextField()
        setUpButtonResgister()
    }
    
    func setUpTextField() {
        tfPassword.delegate = self;
        tfOldPass.delegate = self;
        tfRePassword.delegate = self;
        tfPassword.isSecureTextEntry = true;
        tfRePassword.isSecureTextEntry = true;
        tfOldPass.isSecureTextEntry = true
    }
    
    func setUpButtonResgister()  {
        btnSave?.setRoudary(radius: 4.0);
        isCheckEnableButtonRegister = false;
    }
    
    func checkEnableCreateProfile(){
        btnSave?.isEnabled = isCheckEnableButtonRegister
        btnSave?.alpha = isCheckEnableButtonRegister ? 1 : 0.5
    }
    
    func validateRegister()->Bool{
        var isRegister:Bool = false
        guard isValidateRegister.isValidatePassword,
            isValidateRegister.isValidatePassword,
            isValidateRegister.isValidateConfirmPassword
            else {
                return isRegister
        }
        isRegister = true
        return isRegister
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
                self.showAlertView("Your password incorrect")
            }
        }
    }
}

extension ChangePassVC:UITextFieldDelegate {
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
