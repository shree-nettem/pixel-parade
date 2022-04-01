//
//  String+Localize.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension String {
    
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
