//
//  BannerAPI.swift
//  Pixel-parade
//
//  Created by Nikita Velichkin on 13.10.2020.
//  Copyright © 2020 Live Typing. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum BannerAPI {
    case getBanner
}

extension BannerAPI: TargetType {
    var baseURL: URL {
        URL(string: API.api)!
    }
    
    var path: String {
        "banner"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}
