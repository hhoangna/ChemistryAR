//
//  ARFileModel.swift
//  ChemistryAR
//
//  Created by Admin on 12/8/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import Alamofire

class ARFileModel: BaseModel, Codable {
    var urlServer: String?
    var urlLocal: URL?
    var fileContent: Data?
    var name: String?
    var _id: String?
    var createdAt: Date?
    var updatedAt: Date?
    var active: Bool?
    
    func startDownload(callback: @escaping (Bool,ARFileModel?) -> Void){
        let fileUrl = self.getSaveFileUrl(fileName: E(name))
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
    
        Alamofire.download(E(urlServer), to:destination).downloadProgress { (progress) in
            print("Downloading...(\(progress.fractionCompleted))")
            //self.progressLabel.text = (String)(progress.fractionCompleted)
        }.responseData { (data) in
            print(data)
            print("Download successfull")
            self.urlLocal = data.destinationURL
            self.fileContent = data.result.value

            callback(true,self)
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
}


