//
//  BuildConfiguration.swift
//  ChemistryAR
//
//  Created by Admin on 12/6/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

// Represents the current build scheme
enum BuildScheme: String {
    case debug = "debug"
    case adhoc = "adhoc"
    case release = "release"
    
    init?(rawString: String) {
        self.init(rawValue: rawString.lowercased())
    }
}

enum ServerEnvironment: String {
    case development = "development"
    case testing = "testing"
    case production = "production"
    
    init?(rawString: String) {
        self.init(rawValue: rawString.lowercased())
    }
    
    func displayString() -> String {
        return rawValue.capitalized
    }
}

//MARK: - Commons
/// Handles reading the Info.plist file to pull User-Defined attributes and determine configurations for different features
struct BuildConfiguration {
    fileprivate let infoDictionary: [String: Any]
    
    let buildScheme: BuildScheme
    let serverEnvironment: ServerEnvironment
    
    init?(infoDictionary: [String: Any]) {
        self.infoDictionary = infoDictionary
        
        guard let buildSchemeString = infoDictionary["BUILD_SCHEME"] as? String,
            let buildScheme = BuildScheme(rawString: buildSchemeString) else {
                print("Build Configuration: No BUILD_SCHEME value.");
                return nil;
        }
        self.buildScheme = buildScheme;
        
        guard let serverString = infoDictionary["SERVER"] as? String,
            let serverEnvironment = ServerEnvironment(rawString: serverString) else {
                print("Build Configuration: No SERVER value.");
                return nil;
        }
        
        self.serverEnvironment = serverEnvironment;
    }
}

extension BuildConfiguration {
    func serverUrlString() -> String {
        //TEST
        let  string: String = PATH_REQUEST_URL.BASE_URL.URL
        return string
        
        /*
         let type = SDBuildConf.buildScheme
         switch type {
         case .debug,
         .adhoc:
         return Configuration.baseUrl_Dev
         
         case .release:
         return Configuration.baseUrl_Product
         }
         */
    }
    
    func baseImageUrlString() -> URL {
        return URL(string: "IMAGE_SERVER_URL")!;
    }
}
