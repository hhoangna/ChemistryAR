//
//  Constants + API.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

enum ParamsMethod : String {
    case GET = "GET";
    case POST = "POST";
    case PUT = "PUT";
    case PATCH = "PATCH";
    case DELETE = "DELETE";
    case DISK_SAVING = "DISK_SAVING";
}

enum APIOutput<T, E> {
    case object(T);
    case error(E);
}

enum APIInput {
    case empty;
    case dto(BaseModel); //dto: DataObject
    case json(Any); //dic: Dictionary
    case str(String, in: String?); //str: String
    case data(Data);
//    case mutiFile([AttachFileModel])
}

enum PATH_REQUEST_URL: String {
    
    case BASE_URL = "BASE_URL"
    case LOGIN = "LOGIN"
    
    var URL:String  {
        return E(Configuration.pathUrls[self.rawValue])
    }
}

struct RESTConstants {
    static func getBASEURL() -> String {
        return PATH_REQUEST_URL.BASE_URL.URL
    }
}
