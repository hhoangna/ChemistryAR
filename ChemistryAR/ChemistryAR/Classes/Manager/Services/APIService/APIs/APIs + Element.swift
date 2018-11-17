//
//  APIs + Element.swift
//  ChemistryAR
//
//  Created by Admin on 11/15/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension BaseAPI {
    @discardableResult
    func getAllElement(callback: @escaping APICallback<[ElementModel]>) -> APIRequest{
        
        return request(method: .GET,
                       path: PATH_REQUEST_URL.GET_ALL_ELEMENT.URL,
                       input: .empty,
                       callback: callback)
    }
}
