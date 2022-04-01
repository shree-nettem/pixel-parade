//
//  StickerFull+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//
//

import Foundation
import CoreData

extension StickerFull {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StickerFull> {
        return NSFetchRequest<StickerFull>(entityName: "StickerFull")
    }

    @NSManaged public var filename: String?
    @NSManaged public var id: Int32
    @NSManaged public var position: Int32
    @NSManaged public var stickerpackID: Int32
    @NSManaged public var attribute: NSObject?

}
