//
//  GlobalMethods.swift
//  EasyRouts
//
//  Created by Pavel Pronin on 26/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

// MARK: - Overrided Swift Methods

func releasePrint(_ object: Any) {
    Swift.print(object)
}

func print(_ object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
