//
//  NSAttributedString+Sizes.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    func getSize(widthLimit: CGFloat) -> CGSize {
        let limitedSize = CGSize(width: widthLimit, height: CGFloat.greatestFiniteMagnitude)
        return self.getSize(sizeLimit: limitedSize)
    }
    
    func getSize(heightLimit: CGFloat) -> CGSize {
        let limitedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: heightLimit)
        return self.getSize(sizeLimit: limitedSize)
    }
    
    func getSize(sizeLimit: CGSize) -> CGSize {
        var size = self.boundingRect(with: sizeLimit, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        return size
    }
}
