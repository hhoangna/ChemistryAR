//
//  APIs + User.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension BaseAPI {
    
    @discardableResult
    func getDetailUser(model: UserModel, callback: @escaping APICallback<UserModel>) -> APIRequest{
        
        return request(method: .GET,
                       path: String(format: PATH_REQUEST_URL.GET_DETAIL_USER.URL, E(model._id)),
                       input: .empty,
                       callback: callback)
    }
    
    @discardableResult
    func updateDetailUser(model: UserModel, callback: @escaping APICallback<UserModel>) -> APIRequest{
        
        return request(method: .PUT,
                       path: String(format: PATH_REQUEST_URL.UPDATE_USER.URL, E(model._id)),
                       input: .json(model.bodyUpdate()),
                       callback: callback)
    }
    
    @discardableResult
    func getAllUser(callback: @escaping APICallback<[UserModel]>) -> APIRequest{
        
        return request(method: .GET,
                       path: PATH_REQUEST_URL.GET_ALL_USER.URL,
                       input: .empty,
                       callback: callback)
    }
    
    @discardableResult
    func deactiveUser(model: UserModel, callback: @escaping APICallback<UserModel>) -> APIRequest{
        
        return request(method: .DELETE,
                       path: String(format: PATH_REQUEST_URL.DELETE_USER.URL, E(model._id)),
                       input: .empty,
                       callback: callback)
    }
    
    @discardableResult
    func activeUser(model: UserModel, callback: @escaping APICallback<UserModel>) -> APIRequest{
        
        return request(method: .POST,
                       path: String(format: PATH_REQUEST_URL.ACTIVE_USER.URL, E(model._id)),
                       input: .json(model.activeAccount()),
                       callback: callback)
    }
    
    @discardableResult
    func changePassword(model: PasswordModel, callback: @escaping APICallback<UserModel>) -> APIRequest{
        return request(method: .POST,
                       path: PATH_REQUEST_URL.CHANGE_PASS.URL,
                       input: .dto(model),
                       callback: callback)
    }
}
