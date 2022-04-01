//
//  IAPHelper.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 16/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

final class IAPHelper {
    
    class func fetchReceipt(completion: @escaping (_ receipt: String?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString()
                completion(encryptedReceipt)
            case .error(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    class func buyStickerPack(pack: Pack) {
        guard let platform = PlatformViewController.get() else { return }
        PlatformViewController.showHud()
        IAPHelper.buyStickerPack(id: pack.id, completion: {
            guard let receiptData = SwiftyStoreKit.localReceiptData else {
                PlatformViewController.hideHud()
                platform.showMessage(R.string.localizable.error(), message: "Client error, receipt not found")
                return
            }
            let receiptString = receiptData.base64EncodedString(options: [])
            PackManager.purchasePack(id: pack.id, receipt: receiptString, completion: {
                PackStorage.savePack(id: pack.id, completion: nil)
                PackManager.getPack(id: pack.id, completion: {
                    guard let packName = pack.name else { return }
                    AnalyticsService.log(.packDownloaded(name: packName, packSize: pack.quantity, packCost: pack.price))
                })
                PlatformViewController.hideHud()
                
                runThisInMainThread {
                    platform.reloadTabBar()
                }
                
                guard let restorePurchaseButton = platform.restorePurchaseButton else { return }
                UserStorage.persistRestoredPurchases()
                runThisInMainThread {
                    restorePurchaseButton.removeFromSuperview()
                }
            }, failure: {
                PlatformViewController.hideHud()
                platform.showMessage(R.string.localizable.error(), message: R.string.localizable.errorInternalServer())
            })
        }, failure: { error in
            PlatformViewController.hideHud()
            guard let error = error else { return }
            platform.showMessage(R.string.localizable.error(), message: error.localizedDescription)
        })
    }
    
    // swiftlint:disable cyclomatic_complexity
    class func buyStickerPack(id: Int32, completion: (() -> Void)?, failure: ((_ error: Error?) -> Void)?) {
        SwiftyStoreKit.purchaseProduct(Configuration.identificator + "_\(id)", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                guard let completion = completion else { return }
                completion()
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    print("default error")
                }
                guard let failure = failure else { return }
                
                if (error as NSError).code == SKError.Code.paymentCancelled.rawValue {
                    failure(nil)
                } else {
                    failure(error)
                }
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
    class func retrivePurchases() {
        SwiftyStoreKit.retrieveProductsInfo([Configuration.identificator]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Could not retrieve product info, Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    class func restorePurchases(completion: @escaping (_ hasPurchases: Bool) -> Void, failure: @escaping () -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if !results.restoreFailedPurchases.isEmpty {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                failure()
            } else if !results.restoredPurchases.isEmpty {
                for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                print("Restore Success: \(results.restoredPurchases)")
                completion(true)
            } else {
                UserStorage.persistRestoredPurchases()
                print("Nothing to Restore")
                completion(false)
            }
        }
    }
    
    class func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases where purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                print("purchased: \(purchase)")
            }
        }
    }
    
}
