//
//  NetworkService.swift
//
//  Created by Pavel Pronin on 08/08/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import Moya
import Result

struct NetworkService {
    
    // MARK: - Types
    
    typealias Completion = (Result<Moya.Response, NetworkError>) -> Void
    
    // MARK: - Public methods
    
    static func request<T: TargetType>(target: T, completion: @escaping Completion) -> Cancellable {
        var provider = MoyaProvider<T>()
        if let token = StorageService.shared.getAccessToken() {
            provider = MoyaProvider<T>(plugins: [AccessTokenPlugin(tokenClosure: { return token })])
        }
        let object = provider.request(target, callbackQueue: DispatchQueue.global(qos: .default)) { (response) in
            NetworkService.validate(response, completion: completion)
        }
        return object
    }
    
    static func request<T: TargetType>(target: T, completion: @escaping Completion, progressBlock: @escaping ProgressBlock) -> Cancellable {
        var provider = MoyaProvider<T>()
        if let token = StorageService.shared.getAccessToken() {
            provider = MoyaProvider<T>(plugins: [AccessTokenPlugin(tokenClosure: { return token })])
        }
        let object = provider.request(target, callbackQueue: DispatchQueue.global(qos: .default), progress: progressBlock, completion: { (response) in
            NetworkService.validate(response, completion: completion)
        })
        return object
    }
    
    // MARK: - Private methods
    
    private static func validate(_ response: Result<Moya.Response, MoyaError>, completion: @escaping Completion) {
        LoggerService.creatBy(response)
        guard let value = response.value else {
            guard response.description.contains("\(ErrorCode.noInternetConnection.rawValue)") else {
                completion(Result(error: NetworkError()))
                return
            }
            completion(Result(error: NetworkError(type: ErrorCode.noInternetConnection)))
            return
            
        }
        let code = value.statusCode
        if ValidatorService.isValidCode(code) {
            let result: Result<Moya.Response, NetworkError> = Result(value: value)
            completion(result)
        } else {
            completion(Result(error: NetworkError(code: code, data: response.value?.data)))
        }
    }
    
}
