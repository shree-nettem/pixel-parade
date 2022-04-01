//
//  ExpandableTextView.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 13/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

open class ExpandableTextView: UITextView {
    
    private let placeholder = UITextView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
    }
    
    override open var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            layoutIfNeeded() // needed?
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExpandableTextView.textDidChange), name: UITextView.textDidChangeNotification, object: self)
        configurePlaceholder()
        updatePlaceholderVisibility()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        placeholder.frame = bounds
    }
    
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            self.configurePlaceholder()
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            configurePlaceholder()
        }
    }
    
    open func setTextPlaceholder(_ textPlaceholder: String) {
        placeholder.text = textPlaceholder
    }
    
    open func setTextPlaceholderColor(_ color: UIColor) {
        placeholder.textColor = color
    }
    
    open func setTextPlaceholderFont(_ font: UIFont) {
        placeholder.font = font
    }
    
    open func setTextPlaceholderAccessibilityIdentifier(_ accessibilityIdentifier: String) {
        placeholder.accessibilityIdentifier = accessibilityIdentifier
    }
    
    @objc func textDidChange() {
        updatePlaceholderVisibility()
        scrollToCaret()
    }
    
    private func scrollToCaret() {
        guard let textRange = self.selectedTextRange else { return }
        var rect = caretRect(for: textRange.end)
        rect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height + textContainerInset.bottom))
        
        scrollRectToVisible(rect, animated: false)
    }
    
    private func updatePlaceholderVisibility() {
        text.isEmpty ? showPlaceholder() : hidePlaceholder()
    }
    
    private func showPlaceholder() {
        addSubview(self.placeholder)
    }
    
    private func hidePlaceholder() {
        placeholder.removeFromSuperview()
    }
    
    private func configurePlaceholder() {
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.isEditable = false
        placeholder.isSelectable = false
        placeholder.isUserInteractionEnabled = false
        placeholder.textAlignment = self.textAlignment
        placeholder.textContainerInset = self.textContainerInset
        placeholder.backgroundColor = UIColor.clear
    }
}
