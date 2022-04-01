//
//  Pixel_ParadeUITests.swift
//  Pixel ParadeUITests
//
//  Created by Igor on 07/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import XCTest
import SwiftMonkey

class Pixel_ParadeUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
        XCUIApplication().terminate()
    }

    func testMonkey() {
        let application = XCUIApplication()
        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        let monkey = Monkey(frame: application.frame)
        monkey.addDefaultUIAutomationActions()
        monkey.addXCTestTapAlertAction(interval: 100, application: application)
        monkey.monkeyAround(forDuration: 2700)
    }

}
