//
//  APNSService.swift
//  TemplateProject
//
//  Created by Vladimir Vishnyagov on 05/06/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import Crashlytics
import UserNotifications

enum RemoteNotificationType: String {
    case exampleContentType = "ExampleContentType"
}

protocol APNSServiceListnerProtocol: class {
    func notificationSettingsDidChanged()
}

class APNSService: NSObject {
    
    /// Singleton
    static let shared = APNSService()
    
    /// Observer denied notifications
    weak var delegate: APNSServiceListnerProtocol?
    
    override init() {
        super.init()
        
        updateUserAccess()
    }
    
    private var showNotifications = true
    
    /// User denied access variable
    var accessDenied = false
    
    /// Enabled/Disabled push notifications
    var isRegistredForPushNotifications: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    private func updateUserAccess() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] (settings: UNNotificationSettings) in
            if settings.authorizationStatus == .denied {
                APNSService.shared.accessDenied = true
            } else {
                APNSService.shared.accessDenied = false
            }
            if UIApplication.shared.applicationState == .active, let delegate = self?.delegate {
                runThisInMainThread {
                    delegate.notificationSettingsDidChanged()
                }
            }
        })
    }
    
    /// Show popup for user, when access denied
    func showMessageAccessDenied() {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        rootViewController.showMessage(R.string.localizable.errorNotificationUserMessage(), title: R.string.localizable.errorTitle(), actionTitle: R.string.localizable.ok(), actionBlock: {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl, completionHandler: { success in
                #if DEBUG
                    print("Settings opened: \(success)")
                #endif
                CLSLogv("Settings opened: %@", getVaList([success as CVarArg]))
            })
        })
    }
    
    class func shouldNotShowNotifications() {
        APNSService.shared.showNotifications = false
    }
    
    class func shouldShowNotifications() {
        APNSService.shared.showNotifications = true
    }
    
    class func registerForNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (_, _)  in
            APNSService.shared.updateUserAccess()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    class func unregisterForPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    class func didRegisterForRemoteNotificationsWithDeviceToken(_ token: Data) {
        APNSService.shared.updateUserAccess()
    }
    
    class func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        #if DEBUG
            print(error.localizedDescription)
        #endif
        CLSLogv("didFailToRegisterForRemoteNotificationsWithError: %@", getVaList([error.localizedDescription]))
        APNSService.shared.updateUserAccess()
    }
    
    class func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        guard APNSService.shared.showNotifications else { return }
        guard let rawContentType = userInfo["content_type"] as? String else { return }
        guard let contentType = RemoteNotificationType(rawValue: rawContentType) else { return }
        switch contentType {
        case .exampleContentType:
            APNSService.didReceiveExampleContentType(userInfo)
        }
    }
    
    class func didReceiveExampleContentType(_ userInfo: [AnyHashable: Any]) {}
    
}
