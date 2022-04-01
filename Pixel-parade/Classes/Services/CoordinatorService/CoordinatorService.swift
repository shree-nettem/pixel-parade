//
//  CoordinatorService.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class CoordinatorService {
    
    /// Singleton
    static let shared = CoordinatorService()
    
    private lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window = window
        }
        return window
    }()
    
    // MARK: - Navigation -
    
    func showMainScreen(transition: CATransition? = nil) {
        window?.set(rootViewController: BaseNavigationViewController(rootViewController: UIViewController()), withTransition: transition)
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Helpers -
    
    // MARK: Animation
    
    func standartTransition() -> CATransition {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.duration = 0.35
        return transition
    }
    
    // MARK: Rate App
    
//    func rateApp() {
//        if #available(iOS 10.3, *) {
//            //import StoreKit
//            SKStoreReviewController.requestReview()
//        } else {
//            guard let url = URL(string : "itms-apps://itunes.apple.com/app/\(kApplicationID)") else { return }
//            UIApplication.shared.openURL(url)
//        }
//    }
    
    // MARK: Additional logic
    
    func logout() {
        StorageService.shared.removeAllData()
        CoordinatorService.shared.showMainScreen(transition: self.standartTransition())
    }
}
