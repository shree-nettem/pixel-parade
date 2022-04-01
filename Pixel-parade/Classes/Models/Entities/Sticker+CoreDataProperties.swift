//
//  Sticker+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//
//

import Foundation
import CoreData

extension StickerPreview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StickerPreview> {
        return NSFetchRequest<StickerPreview>(entityName: "StickerPreview")
    }

    @NSManaged public var filename: String?
    @NSManaged public var id: Int32
    @NSManaged public var position: Int32
    @NSManaged public var stickerpackID: Int32
    @NSManaged public var attribute: NSObject?
    @NSManaged public var pack: Pack?

}
