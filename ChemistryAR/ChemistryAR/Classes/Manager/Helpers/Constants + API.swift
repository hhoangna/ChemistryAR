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
    case mutiFile([FileModel])
}

enum PATH_REQUEST_URL: String {
    
    case BASE_URL = "BASE_URL"
    case LOGIN = "LOGIN"
    case SIGNUP = "SIGNUP"
    case GET_ALL_ELEMENT = "GET_ALL_ELEMENT"
    case GET_ALL_COMPOUND = "GET_ALL_COMPOUND"
    case GET_DETAIL_ELEMENT = "GET_DETAIL_ELEMENT"
    case GET_DETAIL_USER = "GET_DETAIL_USER"
    case DELETE_USER = "DELETE_USER"
    case ACTIVE_USER = "ACTIVE_USER"
    case UPDATE_USER = "UPDATE_USER"
    case GET_ALL_USER = "GET_ALL_USER"
    case CHANGE_PASS = "CHANGE_PASS"
    
    var URL:String  {
        return E(Configuration.pathUrls[self.rawValue])
    }
}

struct RESTConstants {
    static func getBASEURL() -> String {
        return PATH_REQUEST_URL.BASE_URL.URL
    }
}
