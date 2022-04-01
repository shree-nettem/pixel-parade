//
//  Date+Format.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension Date {
    
    enum DateFormat: String {
        // swiftlint:disable identifier_name
        case dd_MM_YYYY_Dot = "dd.MM.YYYY"
        case dd_MM_YYYY_Slash = "dd/MM/YYYY"
        case dd_MM_YYYY_Space = "dd MM YYYY"
        case dd_MMM = "dd MMM"
        case hh_mm_ss = "hh:mm:ss"
        case standart = "YYYY-MM-dd HH:MM:SS"
        // swiftlint:enable identifier_name
    }
    
    /// Slow
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    /// Fast if used several times
    func toString(formatter: DateFormatter.DateFormat) -> String {
        let dateFormatter: DateFormatter!
        switch formatter {
        case .standart:
            dateFormatter = DateFormatter.standart
        case .full:
            dateFormatter = DateFormatter.full
        case .fullWithDot:
            dateFormatter = DateFormatter.fullWithDot
        case .short:
            dateFormatter = DateFormatter.short
        case .time:
            dateFormatter = DateFormatter.time
        }
        return dateFormatter.string(from: self)
    }
}
