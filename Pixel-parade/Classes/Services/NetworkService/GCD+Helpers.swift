//
//  GCD+Helpers.swift
//  TemplateProject
//
//  Created by Vladimir Vishnyagov on 04/06/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

public func makeDelayAfter(delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        DispatchQueue.main.async {
            closure()
        }
    }
}

public func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
    runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
}

public func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
    let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: time, execute: after)
}

public func runThisInMainThread(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

public func runThisInBackground(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

public  func runThisEvery(seconds: TimeInterval, startAfterSeconds: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
    let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    return timer!
}
