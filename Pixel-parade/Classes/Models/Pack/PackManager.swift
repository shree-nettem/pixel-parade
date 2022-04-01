//
//  PackManager.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import Sync

final class PackManager {
    
    private static var savedPacks: [[String: Any]] = []
    
    class func getPacks(completion: ((_ isLastPage: Bool) -> Void)?) {
        let page = Int(ceil(Double(savedPacks.count) / 100.0)) + 1
        guard (page > 1 && savedPacks.count % 100 == 0) || savedPacks.isEmpty else {
            PackStorage.syncPacks(packsDictionaries: savedPacks) {}
            completion?(true)
            return
        }
        
        _ = NetworkService.request(target: PackAPI.getPacks(page: page), completion: { (result) in
            switch result {
            case .success(let value):
                do {
                    if let packsDictionaries = try value.mapJSON() as? [[String: Any]] {
                        savedPacks.append(contentsOf: packsDictionaries)
                        completion?(false)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)

                if let completion = completion {
                    completion(true)
                }
            }
        })
    }
    
    class func getPack(id: Int32, completion: (() -> Void)?) {
        _ = NetworkService.request(target: PackAPI.getPack(id: id), completion: { (result) in
            switch result {
            case .success(let value):
                do {
                    if let arrayStickersDictionaries = try value.mapJSON() as? [[String: Any]] {
                        PackStorage.syncFullStickers(id: id, stickersDictionaries: arrayStickersDictionaries, completion: completion)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
                if let completion = completion {
                    completion()
                }
            }
        })
    }
    
    class func purchasePack(id: Int32, receipt: String, completion: (() -> Void)?, failure: (() -> Void)?) {
        _ = NetworkService.request(target: PackAPI.purchase(id: id, receipt: receipt), completion: { (result) in
            switch result {
            case .success(let result):
                do {
                    let success = try result.mapString()
                    if let boolValue = Bool(success), boolValue == true {
                        if let completion = completion {
                            completion()
                            return
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                if let failure = failure {
                    failure()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let failure = failure {
                    failure()
                }
            }
        })
    }
    
    class func restorePurchases(receipt: String, completion: ((_ ids: [Int32]) -> Void)?, failure: (() -> Void)?) {
        _ = NetworkService.request(target: PackAPI.restorePurchases(receipt: receipt), completion: { (result) in
            switch result {
            case .success(let result):
                do {
                    if let ids = try result.mapJSON() as? [Int32] {
                        if let completion = completion {
                            completion(ids)
                            return
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                if let failure = failure {
                    failure()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let failure = failure {
                    failure()
                }
            }

        })
    }

}
