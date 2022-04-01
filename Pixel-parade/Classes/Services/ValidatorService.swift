//
//  ValidatorService.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 04/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation

struct ValidatorService {
    
    /// Response status code validation
    ///
    /// - Parameter code: Status Code
    /// - Returns: Result of validation
    static func isValidCode(_ statusCode: Int) -> Bool {
        guard 200..<300 ~= statusCode else { return false }
        return true
    }
    
}
