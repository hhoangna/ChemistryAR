//
//  UIBarButtonItem + Ext.swift
//  ChemistryAR
//
//  Created by HHumorous on 10/17/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func backButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let insets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 8)
        let button = customButton(with: #imageLiteral(resourceName: "ic_Back"),
                                  highlightedImage: #imageLiteral(resourceName: "ic_Back"),
                                  frame: frame,
                                  imageEdgeInsets: insets,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func searchButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 15, height: 20)
        let insets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
        let button = customButton(with: #imageLiteral(resourceName: "ic_search"),
                                  highlightedImage: #imageLiteral(resourceName: "ic_search"),
                                  frame: frame,
                                  imageEdgeInsets: insets,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func closeButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 0)
        let button = customButton(with: #imageLiteral(resourceName: "ic_removeText"),
                                  highlightedImage: #imageLiteral(resourceName: "ic_removeText"),
                                  frame: frame,
                                  imageEdgeInsets: insets,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func cancelButton(target: Any, action: Selector) -> UIBarButtonItem {
        let button = setUpButtonWithText(text: "Cancel".localized, target: target, action: action)
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func logoutButton(target: Any, action: Selector) -> UIBarButtonItem {
        let button = setUpButtonWithText(text: "LOGOUT".localized, textColor: .red, target: target, action: action)
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func editButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let button = customButton(with: #imageLiteral(resourceName: "ic_editBlue"),
                                  frame: frame,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func saveButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let button = customButton(with: #imageLiteral(resourceName: "ic_checkCircle"),
                                  frame: frame,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func filterButton(target: Any, action: Selector) -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let button = customButton(with: #imageLiteral(resourceName: "ic_Back"),
                                  frame: frame,
                                  target: target,
                                  action: action)
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    fileprivate class func customButton(with image: UIImage,
                                        highlightedImage: UIImage? = nil,
                                        frame: CGRect,
                                        imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
                                        target: Any,
                                        action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = frame
        button.imageEdgeInsets = imageEdgeInsets
        
        return button
    }
    
    fileprivate class func setUpButtonWithText(text:String, textColor: UIColor? = AppColor.black, target:Any,action: Selector) -> UIButton{
        let title = text
        let color = textColor
        let font = AppFont.helveticaRegular(with: 14)
        
        let labelSize = title.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 15),
                                           options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                           attributes: [NSAttributedString.Key.font: font],
                                           context: nil).size
        let frame = CGRect(origin: CGPoint(), size: labelSize)
        
        
        let normalTitle = NSAttributedString.attributedString(with: title, color: color!, font: font, alignment: .right)
        let highlightedTitle = NSAttributedString.attributedString(with: title, color: AppColor.borderColor, font: font, alignment: .right)
        
        let button = customButton(with: normalTitle,
                                  highlightedTitle: highlightedTitle,
                                  frame: frame,
                                  target: target,
                                  action: action)
        return button;
    }
    
    fileprivate class func customButton(with title: NSAttributedString,
                                        highlightedTitle: NSAttributedString? = nil,
                                        frame: CGRect,
                                        target: Any,
                                        action: Selector) ->  UIButton{
        let button = UIButton(type: .custom)
        
        button.setAttributedTitle(title, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = frame
        
        return button
    }
}
