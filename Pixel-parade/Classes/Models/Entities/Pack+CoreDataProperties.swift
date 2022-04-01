//
//  Pack+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//
//

import Foundation
import CoreData

extension Pack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pack> {
        return NSFetchRequest<Pack>(entityName: "Pack")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var isPurchased: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var purchasedDate: NSDate?
    @NSManaged public var quantity: Int32
    @NSManaged public var stickers: NSSet?
    @NSManaged public var position: Int32

}

// MARK: Generated accessors for stickers
extension Pack {

    @objc(addStickersObject:)
    @NSManaged public func addToStickers(_ value: StickerPreview)

    @objc(removeStickersObject:)
    @NSManaged public func removeFromStickers(_ value: StickerPreview)

    @objc(addStickers:)
    @NSManaged public func addToStickers(_ values: NSSet)

    @objc(removeStickers:)
    @NSManaged public func removeFromStickers(_ values: NSSet)

}
