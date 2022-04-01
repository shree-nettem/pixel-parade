//
//  UserDefaults+Objects.swift
//  Pixel-parade
//
//  Created by Nikita Velichkin on 13.10.2020.
//  Copyright © 2020 Live Typing. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var banner: Banner? {
        get {
            guard let banner = object(forKey: #function) as? Data else { return nil }
            
            let decoder = JSONDecoder()
            guard let decodedBanner = try? decoder.decode(Banner.self, from: banner) else { return nil }
            
            return decodedBanner
        }
        set {
            guard let banner = newValue else {
                set(nil, forKey: #function)
                return
            }
            
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(banner) else {
                set(nil, forKey: #function)
                return
            }
            
            set(encoded, forKey: #function)
        }
    }
    
}
