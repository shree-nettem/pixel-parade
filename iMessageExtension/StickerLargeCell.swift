//
//  StickerLargeCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage
import Messages

final class StikerLargeCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: FLAnimatedImageView!
    @IBOutlet private var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectionView.isHidden = true
    }
    
    override var isHighlighted: Bool {
        didSet (newValue) {
            self.selectionView.isHidden = newValue
        }
    }
    
    func fill(sticker: StickerFull) {
        imageView.sd_setImage(with: sticker.filenameBinded, placeholderImage: R.image.sticker_placeholder(), options: [], completed: nil)
    }
    
}
