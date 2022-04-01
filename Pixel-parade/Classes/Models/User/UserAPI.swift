//
//  UserAPI.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 17/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum UserAPI {
    case createToken
    case sendEmail(email: String)
}

extension UserAPI: TargetType {
    
    var headers: [String: String]? {
        switch self {
        case .sendEmail(email: _):
            guard let accessToken = StorageService.shared.getAccessToken() else { return nil }
            return ["Authorization": accessToken]
        default:
            return nil
        }
    }
    
    enum Fields {
        case email
        
        var value: String {
            return String(describing: self)
        }
    }
    
    var baseURL: URL { return URL(string: API.api)! }
    
    var path: String {
        switch self {
        case .createToken:
            return "token/create"
        case .sendEmail(email: _):
            return "email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createToken:
            return .get
        case .sendEmail(email: _):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createToken:
            return nil
        case .sendEmail(email: let email):
            return [Fields.email.value: email]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data { return Data() }
    
    var task: Task {
        switch self {
        case .createToken:
            return .requestPlain
        case .sendEmail(email: _):
            if let parameters = self.parameters {
                return .requestParameters(parameters: parameters, encoding: self.parameterEncoding)
            }
            return .requestPlain
        }
    }
    
    var validate: Bool { return false }
    
}
