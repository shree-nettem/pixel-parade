//
//  EnumService.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 29/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

struct EnumService {
    
    static func iterate<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
    static func count <T: Hashable>(_: T.Type) -> Int {
        var i = 0
        for _ in iterate(T.self) {
            i += 1
        }
        return i
    }
    
}

protocol CaseCountable {
    
    static func count() -> Int
}

extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
    
    static func count() -> Int {
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 } // swiftlint:this redundant_discardable_let
        return count
    }
}
