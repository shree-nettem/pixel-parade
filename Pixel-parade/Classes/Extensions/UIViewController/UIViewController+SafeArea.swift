//
//  UIViewController+SafeArea.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 03/07/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func safeAreaTopInset() -> CGFloat {
        let defaultTopInset = UIApplication.shared.statusBarFrame.height
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return defaultTopInset }
            guard let rootViewController = window.rootViewController else { return defaultTopInset }
            return rootViewController.view.safeAreaInsets.top
        }
        return defaultTopInset
    }
    
    public func safeAreaBottomInset() -> CGFloat {
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            guard let rootViewController = window.rootViewController else { return 0 }
            safeAreaInsets = rootViewController.view.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        return safeAreaInsets.bottom
    }
    
}
