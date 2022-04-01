//
//  JSONHelper.swift
//  USP
//
//  Created by Vladimir Vishnyagov on 08/08/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

final class JSONHelper {
    
    class public func JSONFromFile(resourceName: String) -> [String: Any]? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else { return nil }
        guard let jsonData = NSData(contentsOfFile: path) else { return nil }
        do {
            guard let elementsRawDict = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? [String: Any] else { return nil }
            return elementsRawDict
        } catch {
            return nil
        }
    }
    
    class public func arrayDictionariesFromJSON(resourceName: String, parentKey: String) -> [[String: AnyObject]]? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else { return [[String: AnyObject]]() }
        guard let jsonData = NSData(contentsOfFile: path) else { return [[String: AnyObject]]() }
        do {
            guard let elementsRawDict = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? [[String: AnyObject]] else { return nil }
            return elementsRawDict
        } catch {
            return nil
        }
    }
    
}
