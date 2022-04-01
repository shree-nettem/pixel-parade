//
//  Banner.swift
//  Pixel-parade
//
//  Created by Nikita Velichkin on 13.10.2020.
//  Copyright © 2020 Live Typing. All rights reserved.
//

struct Banner: Codable {
    let id: Int
    let imagePath: String
    let link: String
    
    var imageURL: URL? {
        let scheme = API.Path.current().scheme
        let domain = API.Path.current().domain
        return URL(string: "\(scheme.rawValue)\(domain)\(imagePath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case imagePath = "image"
        case link = "url"
    }
}

struct BannerResponse: Decodable {
    var banner: Banner?
}
