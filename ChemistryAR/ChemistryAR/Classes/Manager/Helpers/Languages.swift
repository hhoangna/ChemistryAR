//
//  Languages.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

enum Language:String {
    case EN = "en"
    case VN = "vi"
}

let LanguageHelper = _LanguageHelper.shared

class _LanguageHelper {
    
    static let shared = _LanguageHelper()
    fileprivate var info: [String: String]?
    
    func setLanguage(forLanguage language: Language) {
        if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable",
                                                              withExtension: "strings",
                                                              subdirectory: "\(language.rawValue).lproj", localization: "en")?.path {
            if FileManager.default.fileExists(atPath: path) {
                // Keep a reference to this dictionary
                info = NSDictionary(contentsOfFile: path) as? [String: String]
            }
        }
    }
    
    func getValue(forKey key: String) -> String {
        if let mInfo = info,
            let value = mInfo[key] {
            return value
        }
        return ""
    }
}
