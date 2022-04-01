//
//  Configuration.swift
//  Pixel-parade
//
//  Created by Владимир Вишнягов on 28/02/2018.
//  Copyright © 2018 Live Typing. All rights reserved.
//

import Foundation

struct Configuration {
    
    static var currentEndPoint: API.PathType = .release
    
    static var endPointDevelop: String = "95.213.251.112"
    
    static var endPointRelease: String = "104.236.79.232"
    
    static var identificator: String = "io.GoodIdeas.Pixel_Parade.stickerpacks"  // "com.ltst.PixelParade.stickerpacks"
    
    static var appGroupContainer: String = "group.pixel-parade.container"  // "group.com.ltst.PixelParade"
    
}
