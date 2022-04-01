//
//  PackAPI.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 17/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum PackAPI {
    case getPacks(page: Int)
    case getPack(id: Int32)
    case purchase(id: Int32, receipt: String)
    case restorePurchases(receipt: String)
    case getTags
}

extension PackAPI: TargetType {
    
    var headers: [String: String]? {
        guard let accessToken = StorageService.shared.getAccessToken() else { return nil }
        return ["Authorization": accessToken]
    }
    
    enum Fields {
        case id
        case receipt
        case page
        
        var value: String {
            return String(describing: self)
        }
    }
    
    var baseURL: URL { return URL(string: API.api)! }
    
    var path: String {
        switch self {
        case .getPacks:
            return "sticker-pack/"
        case .getPack(id: let id):
            return "sticker-pack/\(id)"
        case .purchase(id: let id, receipt: _):
            return "sticker-pack/\(id)/purchase"
        case .restorePurchases(receipt: _):
            return "sticker-pack/restoration-purchases"
        case .getTags:
            return "/key-search-words"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .purchase(id: _, receipt: _), .restorePurchases(receipt: _):
            return .post
        case .getPacks:
            return .get
        case .getPack(id: _), .getTags:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .purchase(id: _, receipt: let receipt), .restorePurchases(receipt: let receipt):
            return [Fields.receipt.value: receipt]
        case let .getPacks(page):
            return [Fields.page.value: page]
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data { return Data() }
    
    var task: Task {
        switch self {
        case .purchase(id: _, receipt: _), .restorePurchases(receipt: _), .getPacks:
            guard let parameters = self.parameters else { return .requestPlain }
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
    
    var validate: Bool { return false }
    
}
