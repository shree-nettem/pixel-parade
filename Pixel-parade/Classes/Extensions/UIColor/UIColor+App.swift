//
//  UIColor+App.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 03/08/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

// MARK: - App colors

extension UIColor {
    
    /// 0, 211, 212
    class var ppAquaBlue: UIColor {
        return UIColor(0, 211, 212)
    }
    
    /// 112, 112, 112
    class var ppGray: UIColor {
        return UIColor(112, 112, 112)
    }
    
    /// 0, 0, 0
    class var ppBlack: UIColor {
        return UIColor(0, 0, 0)
    }
    
    /// 255, 255, 255
    class var ppWhite: UIColor {
        return UIColor(255, 255, 255)
    }
    
    /// 0, 128, 253
    class var ppDeepSkyBlue: UIColor {
        return UIColor(0, 128, 253)
    }
    
    /// 179, 249, 249
    class var ppLightCyan: UIColor {
        return UIColor(179, 249, 249)
    }
    
    /// 137, 137, 137
    class var ppBrownGrey: UIColor {
        return UIColor(137, 137, 137)
        
    }
    
    /// 37, 115, 115
    class var ppDarkGreenBlue: UIColor {
        return UIColor(37, 115, 115)
    }
    
    /// 37, 115, 115,
    class var ppDarkGreenBlueHighlighted: UIColor {
        return UIColor(red: 37/255, green: 115/255, blue: 115/255, alpha: 0.5)
    }

    class var ppAquaBlue2: UIColor {
        return UIColor(4, 235, 237).withAlphaComponent(0.3)
    }

}
