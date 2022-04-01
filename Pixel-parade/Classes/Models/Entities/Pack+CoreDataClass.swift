//
//  Pack+CoreDataClass.swift
//  
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//
//

import Foundation
import CoreData

@objc(Pack)
public class Pack: NSManagedObject {
    
    var nameBinded: String {
        guard let name = name else { return "" }
        return name
    }
    
    var descriptionTextBinded: String {
        guard let descriptionText = descriptionText else { return "" }
        return descriptionText
    }
    
    var stickersArrayBinded: [StickerPreview] {
        guard let stickers = stickers else { return [] }
        guard var stickersArray = stickers.allObjects as? [StickerPreview] else { return [] }
        stickersArray.sort { (stickerOne, stickerTwo) -> Bool in
            return stickerOne.position < stickerTwo.position
        }
        return stickersArray
    }
    
    var stickersFullArrayBinded: [StickerFull] {
        guard let stickers = stickers else { return [] }
        guard var stickersArray = stickers.allObjects as? [StickerFull] else { return [] }
        stickersArray.sort { (stickerOne, stickerTwo) -> Bool in
            return stickerOne.position < stickerTwo.position
        }
        return stickersArray
    }
    
    var stickersCountBinded: String {
        if quantity > 1 {
            return "\(quantity) stickers"
        } else if quantity == 1 {
            return "1 sticker"
        } else {
            return "No stickers"
        }
    }
    
}
