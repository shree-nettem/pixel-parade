//
//  UserManager.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 17/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

final class UserManager: NSObject {
    
    static let shared = UserManager()
    
    private var okAction: UIAlertAction?
    
    class func createToken(completion: (() -> Void)?) {
        _ = NetworkService.request(target: UserAPI.createToken) { (result) in
            switch result {
            case .success(let value):
                do {
                    let token = try value.mapString()
                    guard !token.isEmpty else { return }
                    let start = token.index(token.startIndex, offsetBy: 1)
                    let end = token.index(token.endIndex, offsetBy: -1)
                    let range = start..<end
                    let newToken = String(token[range])
                    StorageService.shared.saveAccessToken(newToken)
                    guard let completion = completion else { return }
                    completion()
                } catch {
                    print(error.localizedDescription)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    class func sendEmail(email: String, completion: (() -> Void)?, failure: (() -> Void)?) {
        _ = NetworkService.request(target: UserAPI.sendEmail(email: email), completion: { result in
            switch result {
            case .success(let result):
                do {
                    if let dictionary = try result.mapJSON() as? [String: Any],
                        dictionary["id"] != nil,
                        dictionary["email"] != nil {
                        guard let completion = completion else { return }
                        completion()
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                }
                guard let failure = failure else { return }
                failure()
            case .failure(let error):
                print(error.localizedDescription)
                guard let failure = failure else { return }
                failure()
            }
        })
    }
    
    class func getUserEmail(completion: (() -> Void)?) {
        guard let plaform = PlatformViewController.get() else {
            guard let completion = completion else { return }
            completion()
            return
        }
        let alertController = UIAlertController(title: R.string.localizable.giveEmailTitle(), message: R.string.localizable.giveEmailMessage(), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .default, handler: { _ in
            AnalyticsService.log(.emailClosed(isEmailProvided: false))
            guard let completion = completion else { return }
            completion()
        })
        UserManager.shared.okAction = UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: { _ in
            guard let textField = alertController.textFields?.first else { return }
            if let email = textField.text {
                AnalyticsService.log(.emailClosed(isEmailProvided: true))
                UserManager.sendEmail(email: email, completion: { 
                    UserStorage.persistEmail(email: email)
                }, failure: {
                    guard let platform = PlatformViewController.get() else { return }
                    platform.showMessage(R.string.localizable.error(), message: "Internal server error, please try again later")
                })
            }
            guard let completion = completion else { return }
            completion()
        })
        UserManager.shared.okAction!.isEnabled = false
        
        alertController.addTextField { textField in
            textField.keyboardType = .emailAddress
            textField.placeholder = "E-mail"
            textField.delegate = UserManager.shared
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(UserManager.shared.okAction!)
        
        plaform.present(alertController, animated: true, completion: nil)
        AnalyticsService.log(.emailPopup)
    }
    
}

// MARK: - UITextFieldDelegate

extension UserManager: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let okAction = okAction else { return true }
        okAction.isEnabled = false
        guard let text = textField.text as NSString? else { return true }
        let email = text.replacingCharacters(in: range, with: string)
        if !email.isEmpty, email.isValidEmail() {
            okAction.isEnabled = true
        }
        return true
    }
    
}
