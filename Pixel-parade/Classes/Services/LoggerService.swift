//
//  LoggerService.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 04/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation
import Moya
import Result

struct LoggerService {
    
    public static func creatBy(_ response: Result<Moya.Response, MoyaError>) {
        #if DEBUG
        let null = "null"
        print("\n************************************************************")
        print("Request: ", response.value?.request?.httpMethod ?? null, response.value?.request?.url?.absoluteString ?? null)
        print("Header: ", response.value?.request?.allHTTPHeaderFields ?? null)
        if let httpBody = String(data: response.value?.request?.httpBody ?? Data(), encoding: .utf8) {
            print("Params: ", httpBody)
        }
        print("Response short: ", response.value?.debugDescription ?? null)
        print("Response full: ", response.value?.response.debugDescription ?? null)
        do {
            let object = try JSONSerialization.jsonObject(with: response.value?.data ?? Data(), options: [])
            if let dictionary = object as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("Data:", string ?? "")
                } catch {
                    print("Data: Data reading error")
                }
            } else if let array = object as? [[String: Any]] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("Data:", string ?? "")
                } catch {
                    print("Data: Data reading error")
                }
            } else {
                print("Data: ", String(data: response.value?.data ?? Data(), encoding: .utf8) ?? null)
            }
        } catch {
            print("Data: Data reading error")
        }
        print("************************************************************\n")
        #endif
    }
    
    private static func getParamsFrom(url: URL) -> [String: Any] {
        var params = [String: String]()
        return URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: Any] in
                params[item.name] = item.value
                return params
            }) ?? [:]
    }
    
}
