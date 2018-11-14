//
//  FileModel.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class FileModel: BaseModel, Codable {
    
    var updatedAt:Date?
    var createdAt:Date?
    var originalname:String?
    var mimetype:String?
    var destination:String?
    var path:String?
    var _id:String?
    var contentFile:Data?
    var type:String?
    var frame:CGSize?
    var mimeType:String? = "application/octet-stream"
    let boundary:String = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    
    var creator: JSONValue<UserModel>?
    var img:FileModel?
    var name:String?
    var link:String?
    var index:Int?
    
    var linkDownload:String {
        get{
            return SERVER_URL.API_FILE.appending(E(path))
        }
    }
    
    
    override func getJSONObject(method: ParamsMethod) -> Any {
        let dic:ResponseDictionary = [:]
        if (method == .POST) { // upload file
            
            //let contentType = "multipart/form-data; boundary=" + boundary
            
            let fileParamConstant = "attachment"
            let boundaryStart = "--\(boundary)\r\n"
            let boundaryEnd = "--\(boundary)--\r\n"
            let contentDispositionString = "Content-Disposition: form-data; name=\"\(fileParamConstant)\"; filename=\"\(E(originalname))\"\r\n"
            
            let contentTypeString = "Content-Type: \(E(mimetype))\r\n\r\n"
            
            let requestBodyData : NSMutableData = NSMutableData()
            
            //value
            requestBodyData.append(boundaryStart.data(using: String.Encoding.utf8)!)
            requestBodyData.append(contentDispositionString.data(using: String.Encoding.utf8)!)
            requestBodyData.append(contentTypeString.data(using: String.Encoding.utf8)!)
            requestBodyData.append(contentFile!)
            requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
            requestBodyData.append(boundaryEnd.data(using:  String.Encoding.utf8)!)
            
            return requestBodyData;
            
        }else {
            
        }
        
        return dic;
    }

}
