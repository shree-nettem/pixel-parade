//
//  UIImage+Images.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 25/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func image(from view: UIView, without hiddenView: UIView) -> UIImage {
        hiddenView.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        hiddenView.isHidden = false
        return image
    }
    
    func trim() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let newRect = cropRect
        guard let imageRef = cgImage.cropping(to: newRect) else { return self }
        return UIImage(cgImage: imageRef)
    }
    
    var cropRect: CGRect {
        guard let cgImage = cgImage else { return .zero }
        guard let context = createARGBBitmapContextFromImage(inImage: cgImage) else { return .zero }
        
        let height = CGFloat(cgImage.height)
        let width = CGFloat(cgImage.width)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else { return .zero }
        
        var lowX = width
        var lowY = height
        var highX: CGFloat = 0
        var highY: CGFloat = 0
        
        let heightInt = Int(height)
        let widthInt = Int(width)
        //Filter through data and look for non-transparent pixels.
        for y in 0 ..< heightInt {
            let y = CGFloat(y)
            for x in 0 ..< widthInt {
                let x = CGFloat(x)
                let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */

                guard data[Int(pixelIndex)] != 0 else { continue } // crop transparent
                if data[Int(pixelIndex+1)] == 0 && data[Int(pixelIndex+2)] == 0 && data[Int(pixelIndex+3)] == 0 { continue } // crop black
                if x < lowX {
                    lowX = x
                }
                if x > highX {
                    highX = x
                }
                if y < lowY {
                    lowY = y
                }
                if y > highY {
                    highY = y
                }
            }
        }
        
        return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
    }
    
    func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {
        
        let width = inImage.width
        let height = inImage.height
        
        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapData = malloc(bitmapByteCount)
        guard bitmapData != nil else { return nil }
        
        let context = CGContext (data: bitmapData,
                                 width: width,
                                 height: height,
                                 bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        return context
    }
    
}
