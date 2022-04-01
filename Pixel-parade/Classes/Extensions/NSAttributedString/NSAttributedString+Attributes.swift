//
//  NSAttributedString+Attributes.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    convenience init(string: String?, font: UIFont, color: UIColor, letterSpacing: CGFloat = 0) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .kern: letterSpacing
            ]
        self.init(string: string ?? "", attributes: attributes)
    }
    
    // MARK: - Mutate
    
    func addLetterSpacing(_ value: CGFloat) -> NSAttributedString {
        if let mutableCopy = self.mutableCopy() as? NSMutableAttributedString {
            mutableCopy.addAttribute(.kern, value: value, range: NSRange.init(location: 0, length: self.length))
            return mutableCopy
        }
        return self
    }
    
    // MARK: - NSParagraphStyle
    
    func addParagraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        if let mutableCopy = self.mutableCopy() as? NSMutableAttributedString {
            mutableCopy.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: self.length))
            return mutableCopy
        }
        return self
    }
    
    // MARK: - Attributes
    
    func addMinimumLineHeight(_ value: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = value
        return self.addParagraphStyle(paragraphStyle)
    }
    
    func addMaximumLineHeight(_ value: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = value
        return self.addParagraphStyle(paragraphStyle)
    }
}
