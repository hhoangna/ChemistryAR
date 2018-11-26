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
    func getElementDetail(elementId: String?, callback: @escaping APICallback<ElementModel>) -> APIRequest{
        
        return request(method: .GET,
                       path: String(format: PATH_REQUEST_URL.GET_DETAIL_ELEMENT.URL, elementId!),
                       input: .empty,
                       callback: callback)
    }
}
