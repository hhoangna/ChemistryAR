//
//  APIs + Reaction.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension BaseAPI {
    
    @discardableResult
    func getReactionEquation(product:String, input:String, callback: @escaping APICallback<ReactionModel>) -> APIRequest{
        var param: String = input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        if product != "" {
            let prStr = product.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            param = "\(param)/\(prStr ?? "")"
        }

        let str = "http://www.studyvn.com/chemistry/find-equation/\(param)?getJSON&type=public"
        return request(method: .GET,
                       serverURL: str,
                       path: "",
                       input: .empty,
                       callback: callback)
    }
}
