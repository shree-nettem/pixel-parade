//
//  StorageService+FileManager.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

private struct FileManagerKeys {
    static let kPath = "kPath"
}

extension StorageService {
    
    func removeAllFiles() {
        let fileManager = FileManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        if let directoryContents = try? fileManager.contentsOfDirectory(atPath: directoryPath) {
            for path in directoryContents {
                let fullPath = (directoryPath as NSString).appendingPathComponent(path)
                do {
                    try fileManager.removeItem(atPath: fullPath)
                    print("Files deleted")
                } catch let error as NSError {
                    print("Error deleting: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func save(data: Data, path: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(path)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Could not data to path:\(path) Error:\(error)")
        }
    }
    
    func save(image: UIImage, path: String) {
        if let jpegImageData = image.jpegData(compressionQuality: 1) {
            save(data: jpegImageData, path: path)
        }
    }
    
    func getData(path: String) -> Data? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(path)
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let data = try Data.init(contentsOf: filePath)
                return data
            } catch {
                print("Could not get data from path:\(path) Error:\(error)")
            }
        }
        return nil
    }
    
    func deleteData(path: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent(path).path
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            }
        } catch {
            print("Could not delete data from path:\(path) Error:\(error)")
        }
    }
}
