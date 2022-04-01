//
//  DragToDeleteView.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 26/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

class DragToDeleteView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var borderView: UIView!
    @IBOutlet var hintLabel: UILabel!
    
    private var borderLayer = CAShapeLayer()
    private let alphaDragToDeleteView: CGFloat = 0.95
    private let borderLineWidth: CGFloat = 2
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    private func customInit() {
        _ = R.nib.dragToDeleteView(owner: self)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        isOpaque = false
        alpha = alphaDragToDeleteView
        addDashedBorder()
        configureHintLabel()
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
        borderLayer.frame = borderView.bounds
    }
    
    // MARK: - Configure
    
    private func configureHintLabel() {
        hintLabel.font = UIFont.systemFont(ofSize: 15)
        hintLabel.textAlignment = .center
        hintLabel.text = R.string.localizable.deleteStickers()
    }
    
    private func addDashedBorder() {
        let color = UIColor.ppBrownGrey.cgColor
        let frameSize = borderView.frame.size
        let shapeRect = CGRect(x: 0, y: borderView.frame.origin.y / borderLineWidth, width: frameSize.width, height: frameSize.height / borderLineWidth)

        borderLayer.frame = borderView.bounds
        borderLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = borderLineWidth
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [6, 3]
        borderLayer.path = UIBezierPath(rect: shapeRect).cgPath

        borderView.layer.addSublayer(borderLayer)
    }

}
