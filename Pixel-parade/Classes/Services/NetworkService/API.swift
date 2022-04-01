//
//  NetworkHost.swift
//
//  Created by Alexander Pryanichnikov on 02/02/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

struct API {
    
    enum Scheme: String {
        case http = "http://"
        case https = "https://"
    }
    
    enum PathType {
        case develop
        case release
    }
    
    struct PathConfiguration {
        var scheme: Scheme
        var domain: String
        var api: String
    }
    
    struct Path {
        
        private static var configurationPath: PathType = Configuration.currentEndPoint
        
        static func current() -> PathConfiguration {
            let api = "/api"
            switch configurationPath {
            case .develop:
                return PathConfiguration(scheme: .http, domain: Configuration.endPointDevelop, api: api)
            case .release:
                return PathConfiguration(scheme: .http, domain: Configuration.endPointRelease, api: api)
            }
        }
        
    }
    
    static var host: String {
        let path = Path.current()
        return path.scheme.rawValue + path.domain
    }
    
    static var api: String {
        let path = Path.current()
        return path.scheme.rawValue + path.domain + path.api
    }
    
}
