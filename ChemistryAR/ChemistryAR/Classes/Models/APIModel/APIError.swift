//
//  APIError.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import Alamofire

class APIError: NSObject {
    var code:BaseAPI.StatusCode?
    var message:String?
    
    override init() {
        super.init()
    }
    
    required init(dataResponse: DataResponse<Any>) {
        super.init()
        code = statusCode(in: dataResponse)
        message = errorMessage(for: dataResponse);
    }
}

fileprivate extension APIError {
    func statusCode(in dataResponse: DataResponse<Any>) -> BaseAPI.StatusCode? {
        guard let statusCode = dataResponse.response?.statusCode else {
            return nil
        }
        
        return BaseAPI.StatusCode(rawValue: statusCode)
    }
    
    func errorMessage(for dataResponse: DataResponse<Any>) -> String? {
        guard let object = dataResponse.value as? ResponseDictionary else {
            return nil
        }
        
        var message = object["ErrorMessage"] as? String
        
        if message == nil {
            message = object["message"] as? String
        }
        if message == nil {
            message = object["results"] as? String
        }
        
        return message
    }
}

