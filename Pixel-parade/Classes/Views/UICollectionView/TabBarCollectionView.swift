//
//  TabBarCollectionView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class TabBarBackgroundView: UIView {
    
    lazy var backgroundTopLineCollectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ppAquaBlue
        return view
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(backgroundTopLineCollectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        #if MAIN_APP
            backgroundTopLineCollectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1)
        #else
            backgroundTopLineCollectionView.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        #endif
    }
    
}
