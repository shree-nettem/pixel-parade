//
//  Array+Mutating.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
    
    func unique() -> [Element] {
        var uniqueValues: [Element] = []
        for item in self {
            if !uniqueValues.contains(item) {
                uniqueValues.append(item)
            }
        }
        return uniqueValues
    }
    
    func containsElement(_ element: Element) -> Bool {
        for e in self where e == element {
            return true
        }
        return false
    }

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

}
