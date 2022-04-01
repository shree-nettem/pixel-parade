//
//  BannerManager.swift
//  Pixel-parade
//
//  Created by Nikita Velichkin on 13.10.2020.
//  Copyright © 2020 Live Typing. All rights reserved.
//

import Foundation

protocol BannerManagerType {
    static func getBanner(completion: @escaping ((Result<Banner?, Error>) -> Void))
}

final class BannerManager: BannerManagerType {
    static func getBanner(completion: @escaping ((Result<Banner?, Error>) -> Void)) {
        let api = BannerAPI.getBanner
        _ = NetworkService.request(target: api) { result in
            switch result {
            case let .success(response):
                guard let bannerResponse = try? response.map(BannerResponse.self) else { return }
                completion(.success(bannerResponse.banner))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func updateBanner(completion: @escaping (() -> Void)) {
        getBanner { result in
            switch result {
            case let .success(banner):
                UserDefaults.standard.banner = banner
                
            case let .failure(error):
                print(error.localizedDescription)
                UserDefaults.standard.banner = nil
            }
            
            completion()
        }
    }
}
