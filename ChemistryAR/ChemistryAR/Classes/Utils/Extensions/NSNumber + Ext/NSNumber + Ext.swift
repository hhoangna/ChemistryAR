//
//  NSNumber + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 11/25/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Double {
    
    func rounded(toDecimalPlaces n: Int) -> Double {
        return Double(String(format: "%.\(n)f", self))!
    }
    
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self.rounded(toDecimalPlaces: 0)) ?? ""
    }
    
    func roundWithSeparator(_ n: Int) -> String {
        return Formatter.withSeparator.string(for: self.rounded(toDecimalPlaces: n)) ?? ""
    }
}
