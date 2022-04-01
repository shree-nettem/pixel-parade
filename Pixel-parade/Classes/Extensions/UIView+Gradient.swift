//
//  UIView+Gradient.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 13/08/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

extension UIView {

    func applyGradient(colors: [UIColor], locations: [NSNumber]?, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        guard let gradientLayer = layer.sublayers?.first(where: { return $0 is CAGradientLayer }) as? CAGradientLayer else {
            let gradientLayer = CAGradientLayer()
            layer.insertSublayer(gradientLayer, at: 0)
            applyGradient(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
            return
        }
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.colors = colors.map { $0.cgColor }
        guard let startPoint = startPoint, let endPoint = endPoint else { gradientLayer.locations = locations; return }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }

    func removeGradientIfExists() {
        guard let gradientLayer = layer.sublayers?.first(where: { return $0 is CAGradientLayer }) as? CAGradientLayer else { return }
        gradientLayer.removeFromSuperlayer()
    }

}
