//
//  APIs.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation

extension BaseAPI {
    
    @discardableResult
    func login(loginModel:LoginModel, callback: @escaping APICallback<LoginResultModel>) -> APIRequest{
        
        return request(method: .POST,
                       path: PATH_REQUEST_URL.LOGIN.URL,
                       input: .dto(loginModel),
                       callback: callback)
    }

    //MARK: - FILES
    
//    // Solution 1
//    @discardableResult
//    func uploadFile(file:AttachFileModel, callback: @escaping APICallback<AttachFileModel>) -> APIRequest {
//        
//        let headers = ["Content-Type":"multipart/form-data; boundary=\(E(file.boundary))"];
//        
//        return request(method: .POST,
//                       serverURL: SERVER_URL.API_FILE,
//                       headers:headers,
//                       path: PATH_REQUEST_URL.UPLOAD_FILE.URL,
//                       input: .dto(file),
//                       callback: callback);
//    }
//    
//    // Solution 2, upload mutifile
//    @discardableResult
//    func uploadFiles(files:[AttachFileModel],
//                     callback: @escaping APICallback<[AttachFileModel]>) -> APIRequest {
//        
//        let headers = ["Content-Type":"multipart/form-data; boundary=\(E(files.first?.boundary))"];
//        
//        return request(method: .POST,
//                       serverURL: SERVER_URL.API_FILE,
//                       headers:headers,
//                       path: PATH_REQUEST_URL.UPLOAD_FILE.URL,
//                       input: .mutiFile(files),
//                       callback: callback);
//    }
//    
//    @discardableResult
//    func downloadFile(file:AttachFileModel,
//                      callback: @escaping APICallback<AttachFileModel>) -> APIRequest {
//        
//        return request(method: .GET,
//                       serverURL: SERVER_URL.API_FILE,
//                       path: E(file.path),
//                       input: .empty,
//                       callback: callback);
//    }
//    
//    func uploadFilesMultipart(files:[AttachFileModel],
//                              callback: @escaping APICallback<[AttachFileModel]>) {
//        
//        let headers = ["Content-Type":"multipart/form-data; boundary=\(E(files.first?.boundary))"];
//        uploadMultipartFormData(method: .POST,
//                                serverURL:SERVER_URL.API_FILE,
//                                headers: headers,
//                                path: PATH_REQUEST_URL.UPLOAD_FILE.URL,
//                                input: files,
//                                callback: callback)
//    }
}
