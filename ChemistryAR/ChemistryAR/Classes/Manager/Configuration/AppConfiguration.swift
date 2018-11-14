//
//  AppConfiguration.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

let Configuration = AppConfiguration.shared

class AppConfiguration: NSObject {
    
    static let shared = AppConfiguration()
    
    // MARK: - Variables
    var trackingTimeInterval:Int = 0
    var pathUrls:[String: String] = [:]
    
    
    // MARK: - Utility Methods
    func enableConfiguration() {
        loadCustomServicesConfigs()
    }
    
    private func loadCustomServicesConfigs() {
        guard let config = readServicesConfigs() else {
            return
        }
        self.pathUrls = config as! [String : String]
    }
    
    private func readConfigurationFile() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "MainConfigs", ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }
    
    private func readServicesConfigs() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "URLServices", ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }
}
