//
//  DateFormatter+Static.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 13/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    enum DateFormat: String {
        case standart = "YYYY-MM-dd hh:mm:ss"
        case short = "dd MMM"
        case full = "dd/MM/YYYY"
        case fullWithDot = "dd.MM.YYYY"
        case time = "hh:mm:ss"
    }
    
    static let standart: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.standart.rawValue
//        formatter.locale = Locale(identifier: "UTC")
//        formatter.timeZone = TimeZone(identifier: "en_US")
        return formatter
    }()
    
    static let fullWithDot: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.fullWithDot.rawValue
        return formatter
    }()
    
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.short.rawValue
        return formatter
    }()
    
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.full.rawValue
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.time.rawValue
        return formatter
    }()
}
