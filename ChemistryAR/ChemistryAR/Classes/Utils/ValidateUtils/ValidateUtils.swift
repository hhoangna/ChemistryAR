
//
//  ValidateUtils.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

protocol ValidateUtils_ {
    
    static func validateEmail(_ email: String) -> Bool;
}


class ValidateUtils : ValidateUtils_ {
    static func validateEmail(_ email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%'+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return predicate.evaluate(with: email);
    }
}
