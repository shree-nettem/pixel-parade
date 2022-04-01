//
//  UIView+Subviews.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ arrayOfViews: [UIView]) {
        for view in arrayOfViews {
            self.addSubview(view)
        }
    }
}
