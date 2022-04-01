//
//  FirebaseAnalyticsLogger.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 01/08/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct FirebaseAnalyticsLogger: AnalyticLogger {

    func log(_ event: AnalyticEvent) {
        Analytics.logEvent(event.eventName, parameters: event.eventParameters)
    }

}
