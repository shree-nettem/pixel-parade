//
//  UIImage+Resize.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 03/07/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(_ image: UIImage, toWidth newWidth: CGFloat) -> CGSize {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
}
