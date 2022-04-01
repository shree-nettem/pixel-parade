//
//  Reusable.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 13/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

/// Represents a UIView that is a reuseable view such as a
/// UITableViewCell, UITableViewHeaderFooterView or UICollectionViewCell.
/// Provides everything necessary for a reusable view to be reused.
internal protocol Reusable: class {
    
    /// Identifier used to dequeue this view for reuse.
    static var reuseIdentifier: String { get }
    
    /// UINib containing the Interface Builder representation.
    static var nib: UINib? { get }
}

/// Provides default implementations of the necessary variables
/// to reuse a generic view.
extension Reusable {
    
    /// Uses the object's Type name as the ReuseIdentifier.
    static var reuseIdentifier: String { return String(describing: self) }
    
    /// Uses the UINib named after the object's type name.
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
}

/// Declares that all UICollectionReusableViews conform to the
/// Reusable protocol and therefore gain the default
/// implementation without any additional effort.
extension UICollectionReusableView: Reusable { }
