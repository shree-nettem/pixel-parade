//
//  String+Converter.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension String {
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter.standart
        return formatter.date(from: self)
    }
}
