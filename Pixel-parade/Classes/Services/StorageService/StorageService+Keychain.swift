//
//  StorageService+Keychain.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
private let kUserAccount = "AuthenticatedUser"
private let kAccessGroup = "SecuritySerivice"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */
private let kAuthorizationToken = "kAuthorizationToken"

// Arguments for the keychain queries
private let kSecClassValue = NSString(format: kSecClass)
private let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
private let kSecValueDataValue = NSString(format: kSecValueData)
private let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
private let kSecAttrServiceValue = NSString(format: kSecAttrService)
private let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
private let kSecReturnDataValue = NSString(format: kSecReturnData)
private let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

extension StorageService {
    
    // MARK: - Public -
    
    /// Call this then application start
    func prepareForStart() {
        if !self.isAppFirstTimeStarted() {
            self.removeAllFromKeychain()
            self.setAppFirstTimeStarted(true)
        }
    }
    
    /// Remove all keys from Keychain
    func removeAllFromKeychain() {
        clearKeychain()
    }
    
    /// Save authorization token in Keychain
    ///
    /// - Parameter token: token value
    func saveAccessToken(_ token: String) {
        self.save(service: kAuthorizationToken, data: token)
    }
    
    /// Get authorization token from Keychain
    ///
    /// - Returns: token value
    func getAccessToken() -> String? {
        return self.load(service: kAuthorizationToken)
    }
    
    // MARK: - Private -

    private func save(service: String, data: String) {
        
        let dataFromString = data.data(using: .utf8, allowLossyConversion: false)
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, kUserAccount, dataFromString ?? Data()], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private func clearKeychain() {
        
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity]
        
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String: secItemClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
    
    private func load(service: String) -> String? {
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, kUserAccount, kCFBooleanTrue ?? true, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?

        guard status == errSecSuccess else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
            return contentsOfKeychain
        }
        guard let retrievedData = dataTypeRef as? Data else { return contentsOfKeychain }
        contentsOfKeychain = String.init(data: retrievedData, encoding: .utf8)
        return contentsOfKeychain
    }
}
