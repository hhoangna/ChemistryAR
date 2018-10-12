//
//  String + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int{
        get { return count }
    }
    
    var isNotEmpty: Bool {
        get { return !isEmpty }
    }
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            let index = base.index(base.startIndex, offsetBy: Int(randomValue))
            randomString += "\(base[index])"
        }
        
        return randomString
    }
    
    var localized: String {
        
        return LanguageHelper.getValue(forKey: self)
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var integerValue: Int {
        return Int(self) ?? 0
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    // MARK: URL
    func encodeURL(allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters);
    }
    
    func encodeURLForMap(allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        let plusAppliedString = replacingOccurrences(of: " ", with: "+", options: .literal, range: nil);
        return plusAppliedString.encodeURL(allowedCharacters: allowedCharacters);
    }
    
    func decodeURL() -> String? {
        return removingPercentEncoding;
    }
    
    // MARK: Others
    func trim(characters : CharacterSet = .whitespaces) -> String {
        return trimmingCharacters(in:characters);
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return self[fromIndex...].toString()//substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return self[..<toIndex].toString()//substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return self[startIndex..<endIndex].toString();
    }
    
    func getWidth(font: UIFont) -> CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func getHeight(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
    
    static func name(first: String?, last: String?) -> String {
        return "\(first?.capitalized ?? "") \(last?.capitalized ?? "")";
    }
    
    // MARK: example
    private func example(){
        
        
        let str = "abc...xyz";
        
        _ = str.encodeURL();
        _ = str.decodeURL();
        
        _ = str.trim();
    }
    
}

//MARK: - HTML
extension String {
    /// Returns an html decoded string, if any part of the decoding fails it returns itself
    func htmlDecodedStringOrSelf() -> String {
        guard contains("&"), contains(";"), let htmlData = data(using: .utf8, allowLossyConversion: false) else {
            return self
        }
        
        do {
            let attributedString =
                try NSAttributedString(data: htmlData,
                                       options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                 NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}

//MARK: - Substring
extension Substring {
    func toString() -> String{
        return String(self);
    }
}
