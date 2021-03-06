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

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    //    subscript (r: Range<Int>) -> String {
    //        let start = index(startIndex, offsetBy: r.lowerBound)
    //        let end = index(startIndex, offsetBy: r.upperBound)
    //        return String(self[Range(start..<end)])
    //    }
    
    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        }
    }
}

// MARK: - NSAttributedString extensions
public extension String {
    
    /// Regular string.
    public var regular: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// Bold string.
    public var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// Underlined string
    public var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    /// Strikethrough string.
    public var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    /// Italic string.
    public var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    public func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
}

extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    
    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

extension Character {
    var unicode: String {
        // See table here: https://en.wikipedia.org/wiki/Unicode_subscripts_and_superscripts
        let unicodeChars = [Character("0"):"\u{2070}",
                            Character("1"):"\u{00B9}",
                            Character("2"):"\u{00B2}",
                            Character("3"):"\u{00B3}",
                            Character("4"):"\u{2074}",
                            Character("5"):"\u{2075}",
                            Character("6"):"\u{2076}",
                            Character("7"):"\u{2077}",
                            Character("8"):"\u{2078}",
                            Character("9"):"\u{2079}",
                            Character("i"):"\u{2071}",
                            Character("+"):"\u{207A}",
                            Character("-"):"\u{207B}",
                            Character("="):"\u{207C}",
                            Character("("):"\u{207D}",
                            Character(")"):"\u{207E}",
                            Character("n"):"\u{207F}"]
        
        if let unicode = unicodeChars[self] {
            return unicode
        }
        
        return String(self)
    }
}

extension String {
    var unicodeSuperscript: String {
        let char = Character(self)
        return char.unicode
    }
    
    func superscripted() -> String {
        let regex = try! NSRegularExpression(pattern: "\\^\\{([^\\}]*)\\}")
        var unprocessedString = self
        var resultString = String()
        
        while let match = regex.firstMatch(in: unprocessedString, options: .reportCompletion, range: NSRange(location: 0, length: unprocessedString.count)) {
            // add substring before match
            let substringRange = unprocessedString.index(unprocessedString.startIndex, offsetBy: match.range.location)
            let subString = unprocessedString.prefix(upTo: substringRange)
            resultString.append(String(subString))
            
            // add match with subscripted style
            let capturedSubstring = NSAttributedString(string: unprocessedString).attributedSubstring(from: match.range(at: 1)).mutableCopy() as! NSMutableAttributedString
            capturedSubstring.string.forEach { (char) in
                let superScript = char.unicode
                let string = NSAttributedString(string: superScript)
                resultString.append(string.string)
            }
            
            // strip off the processed part
            unprocessedString.deleteCharactersInRange(range: NSRange(location: 0, length: match.range.location + match.range.length))
        }
        
        // add substring after last match
        resultString.append(unprocessedString)
        return resultString
    }
    
    mutating func deleteCharactersInRange(range: NSRange) {
        let mutableSelf = NSMutableString(string: self)
        mutableSelf.deleteCharacters(in: range)
        self = mutableSelf as String
    }
}
