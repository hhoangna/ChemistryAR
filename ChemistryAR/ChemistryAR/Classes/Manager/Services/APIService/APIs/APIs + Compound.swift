//
//  APIs + Compound.swift
//  ChemistryAR
//
//  Created by Admin on 12/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension BaseAPI {
//    @discardableResult
//    func getElementDetail(elementId: String, callback: @escaping APICallback<ElementModel>) -> APIRequest{
//
//        return request(method: .GET,
//                       path: String(format: PATH_REQUEST_URL.GET_DETAIL_ELEMENT.URL, elementId),
//                       input: .empty,
//                       callback: callback)
//    }
//
//    @discardableResult
//    func filterElement(text: String, callback: @escaping APICallback<[ElementModel]>) -> APIRequest{
//
//        return request(method: .GET,
//                       path: String(format: PATH_REQUEST_URL.GET_ALL_ELEMENT.URL, text),
//                       input: .empty,
//                       callback: callback)
//    }
    
    @discardableResult
    func getAllCompound(callback: @escaping APICallback<[ARFileModel]>) -> APIRequest{
        
        return request(method: .GET,
                       path: String(format: PATH_REQUEST_URL.GET_ALL_COMPOUND.URL),
                       input: .empty,
                       callback: callback)
    }
}

