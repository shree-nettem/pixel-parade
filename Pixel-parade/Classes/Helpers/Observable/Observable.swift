//
//  Observable.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 13/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation

// Be aware this is not thread safe!
// Why class? https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20160711/002580.html
public class Observable<T> {
    
    public init(_ value: T) {
        self.value = value
    }
    
    public var value: T {
        didSet {
            self.cleanDeadObservers()
            for observer in self.observers {
                observer.closure(oldValue, self.value)
            }
        }
    }
    
    public func observe(_ observer: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.observers.append(Observer(owner: observer, closure: closure))
        self.cleanDeadObservers()
    }
    
    private func cleanDeadObservers() {
        self.observers = self.observers.filter { $0.owner != nil }
    }
    
    private lazy var observers = [Observer<T>]()
}

private struct Observer<T> {
    weak var owner: AnyObject?
    let closure: (_ old: T, _ new: T) -> Void
    init (owner: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.owner = owner
        self.closure = closure
    }
}
