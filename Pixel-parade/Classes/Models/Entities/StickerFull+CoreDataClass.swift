//
//  StickerFull+CoreDataClass.swift
//  
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//
//

import Foundation
import CoreData

@objc(StickerFull)
public class StickerFull: NSManagedObject {

    var filenameBinded: URL {
        guard let filenameString = self.filename else {
            return URL(string: "bad_url")!
        }
        guard let url = URL(string: API.host + "/" + filenameString) else {
            return URL(string: "bad_url")!
        }
        return url
    }
    
}
