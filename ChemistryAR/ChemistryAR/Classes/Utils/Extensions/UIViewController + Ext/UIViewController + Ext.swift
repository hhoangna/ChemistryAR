
//
//  UIViewController + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static func load<T>(SB: SBName) -> T {
        return UIStoryboard(name: SB.rawValue,
                            bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: T.self)) as! T;
    }
    
    public static func load<T: UIViewController>(nib: String? = nil) -> T {
        return T(nibName: nib != nil ? nib : String(describing: T.self),
                 bundle: nil);
    }
    
    public func showAlertView(_ message: String, positiveTitle: String? = nil, positiveAction:((_ action: UIAlertAction) -> Void)? = nil, negativeTitle: String? = nil, negativeAction: ((_ action: UIAlertAction) -> Void)? = nil)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: isEmpty(positiveTitle) ? "OK".localized : positiveTitle, style: .default, handler: positiveAction)
        if negativeAction != nil {
            let cancelAction = UIAlertAction(title: isEmpty(negativeTitle) ? "Cancel".localized : negativeTitle, style: .cancel, handler: negativeAction)
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
