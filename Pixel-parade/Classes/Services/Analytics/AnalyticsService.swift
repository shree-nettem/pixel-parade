//
//  AnalyticsService.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 01/08/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation

class AnalyticsService {
    
    private static var shared = AnalyticsService()
    var loggers: [AnalyticLogger] = []

    static func log(_ eventType: AnalyticEventType) {
        shared.log(eventType.value)
    }

    private func log(_ event: AnalyticEvent) {
        for logger in loggers {
            logger.log(event)
        }
    }

    static func set(_ loggers: [AnalyticLogger]) {
        shared.loggers = loggers
    }

}
