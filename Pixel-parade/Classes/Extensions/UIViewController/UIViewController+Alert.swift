//
//  UIViewController+Alert.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias Action = () -> Void
    
    func showMessage(_ title: String?, message: String? = nil) {
        guard let message = message else { return }
        guard !message.isEmpty else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
        runThisInMainThread { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showMessage(_ message: String?, title: String? = nil, actionTitle: String, actionBlock: Action?) {
        guard let message = message else { return }
        guard !message.isEmpty else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in
            guard let actionBlock = actionBlock else { return }
            actionBlock()
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .cancel, handler: nil))
        
        runThisInMainThread { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alert, animated: true, completion: nil)
        }
    }
    
    func showMessage(_ message: String?, title: String? = nil, dismissTitle: String, dismissBlock: Action?) {
        guard let message = message else { return }
        guard !message.isEmpty else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissTitle, style: .destructive, handler: { _ in
            guard let dismissBlock = dismissBlock else { return }
            dismissBlock()
        }))
        let cancelButton = UIAlertAction(title: R.string.localizable.cancel(), style: .default, handler: nil)
        alert.addAction(cancelButton)
        alert.preferredAction = cancelButton
        
        runThisInMainThread { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alert, animated: true, completion: nil)
        }
    }
    
}
