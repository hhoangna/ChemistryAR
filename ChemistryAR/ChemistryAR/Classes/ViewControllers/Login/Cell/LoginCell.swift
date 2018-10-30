//
//  LoginCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ObjectMapper

class LoginCell: BaseClvCell {
    @IBOutlet fileprivate weak var tfUsername: UITextField?
    @IBOutlet fileprivate weak var tfPassword: UITextField?
    @IBOutlet fileprivate weak var viewLogin: UIView?
    @IBOutlet fileprivate weak var btnLogin: UIButton?
    
    var db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    @IBAction func onbtnClickLogin(button: UIButton) {
        
        guard let username = tfUsername?.text,
            let password = tfPassword?.text else { return }
        
        App().showLoadingIndicator()
        Auth.auth().signIn(withEmail: username, password: password) { (result, err) in
            if err != nil {
                App().dismissLoadingIndicator()
                App().showMessageNotice(title: "Login Failed!", presentationStyle: .center, styleView: .centeredView, styleTheme: .error)
            } else {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                self.db.collection("Users").document(uid).getDocument(completion: { (document, err) in
                    if let user = document.flatMap({
                        $0.data().flatMap({ (data) in
                            return Mapper<UserModel>().map(JSON: data)
                        })
                    }) {
                        Caches().token = E(user.token)
                        Caches().setUser(user.user)
                        App().dismissLoadingIndicator()
                        App().onLoginSuccess()
                    }
                })
            }
        }
    }
}
