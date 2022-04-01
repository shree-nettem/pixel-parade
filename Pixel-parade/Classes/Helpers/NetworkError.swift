//
//  NetworkError.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 04/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation
import Moya

enum ErrorCode: Int, RawRepresentable {
    case unknown
    case noInternetConnection = -1009
    case canceled = -50
    case badRequest = 400
    case unathorized = 401
    case forbidden = 403
    case notFound = 404
    case requestTimeout = 408
    case conflictHttpException = 409
    case unprocessableEntity = 422
    case restricted = 423
    case internalServerError = 500
    case badGateway = 503
    case clientParsingError = 700 /// Error describing when key not found in dictionary, or any not cast in needed type
}

struct NetworkError: Swift.Error {
    
    let type: ErrorCode
    let message: String
    
    init() {
        self.type = .unknown
        self.message = ""
    }
    
    init(type: ErrorCode) {
        self.type = type
        self.message = String(describing: type)
    }
    
    init(code: Int, data: Data? = nil) {
        self.type = ErrorCode(rawValue: code) ?? ErrorCode.unknown
        guard let data = data else {
            self.message = String(describing: ErrorCode.unknown)
            return
        }
        do {
            self.message = try NetworkError.message(data: data)
        } catch {
            self.message = error.localizedDescription
        }
    }
    
    static func message(data: Data) throws -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json as? [String: Any] {
                guard let message = json["message"] as? String else { throw NetworkError(type: .clientParsingError) }
                return message
            } else if let json = json as? [Any] {
                for value in json {
                    guard let value = value as? [String: Any] else { throw NetworkError(type: .clientParsingError) }
                    guard let message = value["message"] as? String else { throw NetworkError(type: .clientParsingError) }
                    return message
                }
            }
            throw NetworkError(type: .clientParsingError)
        } catch {
            throw error
        }
    }
    
}
