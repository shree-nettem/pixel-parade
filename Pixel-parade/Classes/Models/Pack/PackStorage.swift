//
//  PackStorage.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import CoreData
import Sync

final class PackStorage {
    
    class func getPacks(context: NSManagedObjectContext) -> [Pack] {
        let fetchRequest: NSFetchRequest <Pack> = Pack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return [] }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func getPacks(ids: [Int32], context: NSManagedObjectContext) -> [Pack] {
        let fetchRequest: NSFetchRequest <Pack> = Pack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return [] }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func getPacks(context: NSManagedObjectContext, isPurchased: Bool) -> [Pack] {
        let fetchRequest: NSFetchRequest <Pack> = Pack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPurchased = %@", NSNumber(value: isPurchased))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return [] }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func getPreviewStickers(context: NSManagedObjectContext) -> [StickerPreview] {
        let fetchRequest: NSFetchRequest <StickerPreview> = StickerPreview.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return [] }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func getStickers(packID: Int32, context: NSManagedObjectContext) -> [StickerPreview] {
        let fetchRequest: NSFetchRequest <StickerPreview> = StickerPreview.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stickerpackID = %i AND pack = null", packID)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return [] }
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func getPack(id: Int32, context: NSManagedObjectContext) -> Pack? {
        let fetchRequest: NSFetchRequest <Pack> = Pack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return nil }
            return result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func getFirstBoughtPackId() -> Int32? {
        let fetchRequest: NSFetchRequest <Pack> = Pack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPurchased = true")
        let purchasedDateSortDescriptor = NSSortDescriptor(key: "purchasedDate", ascending: false)
        let positionSortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [purchasedDateSortDescriptor, positionSortDescriptor]
        do {
            let result = try StorageService.shared.dataStack.viewContext.fetch(fetchRequest)
            guard !result.isEmpty else { return nil }
            return result.first?.id
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func savePack(id: Int32, completion: (() -> Void)?) {
        StorageService.shared.dataStack.performInNewBackgroundContext { (context) in
            guard let pack = PackStorage.getPack(id: id, context: context) else {
                guard let completion = completion else { return }
                completion()
                return
            }
            pack.isPurchased = true
            pack.purchasedDate = Date() as NSDate
            do {
                try context.save()
                if let completion = completion {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    static func syncPacks(packsDictionaries: [[String: Any]], completion: (() -> Void)?) {
        Sync.changes(packsDictionaries, inEntityNamed: NSStringFromClass(Pack.self), dataStack: StorageService.shared.dataStack) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let completion = completion {
                runThisInMainThread {
                    completion()
                }
            }
        }
    }
    
    static func syncFullStickers(id: Int32, stickersDictionaries: [[String: Any]], completion: (() -> Void)?) {
        let predicate = NSPredicate(format: "stickerpackID = %i", id)
        Sync.changes(stickersDictionaries, inEntityNamed: NSStringFromClass(StickerFull.self), predicate: predicate, dataStack: StorageService.shared.dataStack) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let completion = completion {
                runThisInMainThread {
                    completion()
                }
            }
        }
    }
    
    static func syncRestoredPurchases(ids: [Int32], completion: (() -> Void)?) {
        StorageService.shared.dataStack.performInNewBackgroundContext { (context) in
            let packs = PackStorage.getPacks(ids: ids, context: context)
            guard !packs.isEmpty else { return }
            _ = packs.map({ $0.isPurchased = true })
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            guard let completion = completion else { return }
            runThisInMainThread {
                completion()
            }
        }
    }
    
}
