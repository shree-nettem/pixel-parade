//
//  StorageService+UserDefaults.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

private let defaults = UserDefaults.standard

private struct UserDefaultsKeys {
    static let kApplicationFirstTimeStarted = "kApplicationFirstTimeStarted"
}
extension StorageService {
    
    func removeAllDefaults() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
    
    /// Application first time started
    
    func isAppFirstTimeStarted() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.kApplicationFirstTimeStarted)
    }
    
    func setAppFirstTimeStarted(_ isFirst: Bool) {
        defaults.set(isFirst, forKey: UserDefaultsKeys.kApplicationFirstTimeStarted)
        defaults.synchronize()
    }
}
