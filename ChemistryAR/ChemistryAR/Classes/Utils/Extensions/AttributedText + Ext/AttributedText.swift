//
//  AttributedText.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

public enum AttributedTextBlock {
    
    case header1(String)
    case header2(String)
    case normal(String)
    case list(String)
    
    var text: NSMutableAttributedString {
        let attributedString: NSMutableAttributedString
        switch self {
        case .header1(let value):
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black]
            attributedString = NSMutableAttributedString(string: value, attributes: attributes)
        case .header2(let value):
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.black]
            attributedString = NSMutableAttributedString(string: value, attributes: attributes)
        case .normal(let value):
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
            attributedString = NSMutableAttributedString(string: value, attributes: attributes)
        case .list(let value):
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
            attributedString = NSMutableAttributedString(string: "∙ " + value, attributes: attributes)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.paragraphSpacing = 10
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
}

extension NSMutableAttributedString
{
    enum scripting : Int
    {
        case aSub = -1
        case aSuper = 1
    }
    
    func characterSubscriptAndSuperscript(string:String,
                                          characters:[Character],
                                          type:scripting,
                                          fontSize:CGFloat,
                                          scriptFontSize:CGFloat,
                                          offSet:Int,
                                          length:[Int],
                                          alignment:NSTextAlignment)-> NSMutableAttributedString
    {
        let paraghraphStyle = NSMutableParagraphStyle()
        // Set The Paragraph aligmnet , you can ignore this part and delet off the function
        paraghraphStyle.alignment = alignment
        
        var scriptedCharaterLocation = Int()
        //Define the fonts you want to use and sizes
        let stringFont = UIFont.boldSystemFont(ofSize: fontSize)
        let scriptFont = UIFont.boldSystemFont(ofSize: scriptFontSize)
        // Define Attributes of the text body , this part can be removed of the function
        let attString = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font:stringFont,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.paragraphStyle: paraghraphStyle])
        
        // the enum is used here declaring the required offset
        let baseLineOffset = offSet * type.rawValue
        // enumerated the main text characters using a for loop
        for (i,c) in string.characters.enumerated()
        {
            // enumerated the array of first characters to subscript
            for (theLength,aCharacter) in characters.enumerated()
            {
                if c == aCharacter
                {
                    // Get to location of the first character
                    scriptedCharaterLocation = i
                    //Now set attributes starting from the character above
                    attString.setAttributes([NSAttributedString.Key.font:scriptFont,
                                             // baseline off set from . the enum i.e. +/- 1
                        NSAttributedString.Key.baselineOffset:baseLineOffset,
                        NSAttributedString.Key.foregroundColor:UIColor.black],
                                            // the range from above location
                        range:NSRange(location:scriptedCharaterLocation,
                                      // you define the length in the length array
                            // if subscripting at different location
                            // you need to define the length for each one
                            length:length[theLength]))
                    
                }
            }
        }
        return attString
    }
}

extension NSAttributedString {
    class func attributesDictionary(with color: UIColor, font: UIFont, alignment: NSTextAlignment? = nil, kerning: Float? = nil) -> [NSAttributedString.Key: Any] {
        
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                        NSAttributedString.Key.foregroundColor: color]
        
        if let alignment = alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            paragraphStyle.lineBreakMode = .byTruncatingTail
            
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        
        if let kerning = kerning {
            attributes[NSAttributedString.Key.kern] = NSNumber(value: kerning)
        }
        
        return attributes
    }
    
    class func attributedString(with text: String, color: UIColor, font: UIFont, alignment: NSTextAlignment? = nil, kerning: Float? = nil) -> NSAttributedString {
        let attributes = attributesDictionary(with: color, font: font, alignment: alignment, kerning: kerning)
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
