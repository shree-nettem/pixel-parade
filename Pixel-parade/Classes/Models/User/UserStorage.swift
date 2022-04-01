//
//  UserStorage.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 18/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

final class UserStorage {
    
    private static let kRestoredPurchases = "kRestoredPurchases"
    private static let kDefaultsUserStoredEmail = "kDefaultsUserStoredEmail"
    
    class func fetchRestoredPurchases() -> Bool {
        return UserDefaults.standard.bool(forKey: kRestoredPurchases)
    }
    
    class func persistRestoredPurchases() {
        UserDefaults.standard.setValue(true, forKey: kRestoredPurchases)
        UserDefaults.standard.synchronize()
    }
    
    class func fetchEmail() -> String? {
        return UserDefaults.standard.value(forKey: kDefaultsUserStoredEmail) as? String
    }
    
    class func persistEmail(email: String) {
        UserDefaults.standard.setValue(email, forKey: kDefaultsUserStoredEmail)
        UserDefaults.standard.synchronize()
    }
    
}
