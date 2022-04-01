//
//  NSParagraphStyle+Styles.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension NSParagraphStyle {
    
    func add(textAlignment: NSTextAlignment? = nil, lineSpacing: CGFloat? = nil, minimumLineHeight: CGFloat? = nil) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            if textAlignment != nil {
                mutableCopy.alignment = textAlignment!
            }
            if lineSpacing != nil {
                mutableCopy.lineSpacing = lineSpacing!
            }
            if minimumLineHeight != nil {
                mutableCopy.minimumLineHeight = minimumLineHeight!
            }
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
    func addAligment(_ textAlignment: NSTextAlignment) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            mutableCopy.alignment = textAlignment
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
    func addLineSpacing(_ lineSpacing: CGFloat) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            mutableCopy.lineSpacing = lineSpacing
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
    func addMinimumLineHeight(_ minimumLineHeight: CGFloat) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            mutableCopy.minimumLineHeight = minimumLineHeight
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
    func addMaximumLineHeight(_ maximumLineHeight: CGFloat) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            mutableCopy.maximumLineHeight = maximumLineHeight
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
    func addLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSParagraphStyle {
        if let mutableCopy = self.mutableCopy() as? NSMutableParagraphStyle {
            mutableCopy.lineBreakMode = lineBreakMode
            return mutableCopy
        }
        return NSParagraphStyle()
    }
    
}
