//
//  EmailValidation.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 18/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}
