//
//  File.swift
//
//  Created by Alexander Pryanichnikov on 30/01/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

protocol FileProtocol {
    var data: Data { get }
    var fieldName: String { get }
    var fileName: String { get }
    var mimeType: String { get }
}

enum FileType {
    case video
    case image
    case audio
}

class File: FileProtocol {
    
    /// The data to encode into the multipart form data
    let data: Data
    /// The name to associate with the data in the `Content-Disposition` HTTP header
    let fieldName: String
    /// The filename to associate with the data in the `Content-Disposition` HTTP header
    let fileName: String
    /// The MIME type to associate with the data in the `Content-Type` HTTP header
    let mimeType: String
    /// Current type of file
    let fileType: FileType
    
    init(data: Data, fieldName: String, type: FileType) {
        self.data = data
        self.fieldName = fieldName
        self.fileType = type
        
        switch type {
        case .video:
            self.fileName = "video.mp4"
            self.mimeType = "video/mp4"
        case .image:
            self.fileName = "image.jpg"
            self.mimeType = "image/jpeg"
        case .audio:
            self.fileName = "audio.aac"
            self.mimeType = "audio/aac"
        }
    }
}
