//
//  UIViewController+Sharing.swift
//  RocketGo
//
//  Created by Vladimir Vishnyagov on 24/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func shareContent(_ shareItems: [Any], presenter: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.airDrop, .postToFacebook]
        presenter.present(activityViewController, animated: true, completion: nil)
    }
    
}
