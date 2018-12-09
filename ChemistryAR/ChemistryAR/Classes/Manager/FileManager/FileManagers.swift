//
//  FileManager.swift
//  ChemistryAR
//
//  Created by Admin on 12/8/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation


class FileManagers {
    
    func saveListARFileModel(_ files:[ARFileModel])  {
        files.forEach { (file) in
            saveARFileModel(file)
        }
    }
    
    func saveARFileModel(_ file:ARFileModel) {
        writeDataToPath(data: file.getDataObject(),
                        filePath: getPathBy(nameFile: file.name))
    }
    
    func getPathBy(nameFile: String?) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let folder = URL(fileURLWithPath: paths[0]).appendingPathComponent("ChemistryIR").absoluteString
        let folderPath = folder.trimmingCharacters(in: CharacterSet(charactersIn: "file://"))
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath) {
            try? fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let path = URL(fileURLWithPath: folderPath).appendingPathComponent("file_\(nameFile ?? "")")
        print("Saved to path:\(path)")
        
        return path
    }
    
    func writeDataToPath(data:Data?, filePath:URL?) {
        if let encodedData = data {
            do {
                try encodedData.write(to: filePath!)
            }
            catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
}
