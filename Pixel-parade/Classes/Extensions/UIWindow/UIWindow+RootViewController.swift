//
//  UIWindow+RootViewController.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension UIWindow {
    
    /// Change rootViewController (leak free, animatable)
    ///
    /// - Parameters:
    ///   - newRootViewController:
    ///   - transition:
    func set(rootViewController newRootVC: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootVC
        
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootVC.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootVC.setNeedsStatusBarAppearanceUpdate()
        }
        
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            previousViewController.dismiss(animated: false) {
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
