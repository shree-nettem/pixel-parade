//
//  StorageService.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import CoreData
import Sync

class StorageService {
    
    let modelName = "PixelParade"
    
    static let shared = StorageService()
    
    // MARK: Sync
    
    lazy var containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Configuration.appGroupContainer)!
    lazy var dataStack = DataStack(modelName: modelName,
                                              bundle: Bundle.main,
                                              storeType: .sqLite,
                                              storeName: modelName,
                                              containerURL: self.containerURL)
    
    // MARK: - Actions
    
    private func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // MARK: - Core Data stack
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    } ()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    } ()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    } ()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    } ()
}

// MARK: - Core Data support

extension StorageService {
    
    func saveContext() {
        guard !managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    private func controllerForRequest(request: NSFetchRequest<NSFetchRequestResult>, keyPath: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let controller = NSFetchedResultsController.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: keyPath, cacheName: nil)
        
        do {
            _ = try controller.performFetch()
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return controller
    }
    
    private func fetchObjectsForRequest(request: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject]? {
        var fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try StorageService.shared.managedObjectContext.fetch(request)
        } catch {
            print(error)
        }
        return fetchedObjects ?? nil
    }
    
    func removeAllData() {
        self.removeAllDefaults()
        self.removeAllFromKeychain()
        self.removeAllFiles()
    }
    
    private func deleteEntity(withName name: String) {
        let deleteEntity = {(request: NSFetchRequest<NSFetchRequestResult>) -> Void in
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try self.managedObjectContext.execute(batchDeleteRequest)
            } catch {
                print("Error while delete entity")
            }
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        deleteEntity(fetchRequest)
    }
}
