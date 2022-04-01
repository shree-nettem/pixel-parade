//
//  AppDelegate.swift
//
//  Created by Alexander Pryanichnikov on 26/01/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SDWebImage
import SwiftyStoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IAPHelper.completeTransactions()
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        AnalyticsService.set([FirebaseAnalyticsLogger()])
        if !StorageService.shared.isAppFirstTimeStarted() {
            AnalyticsService.log(.appFirstLaunch)
        } else {
            AnalyticsService.log(.sessionStart)
        }
        StorageService.shared.prepareForStart()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        PlatformViewController.showShop()
        return true
    }

}
