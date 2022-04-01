//
//  SearchService.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 02/08/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation

class SearchService {

    class func fetchTags(success: @escaping (([String]) -> Void), failure: @escaping ((Error) -> Void)) {
        let target: PackAPI = .getTags
        _ = NetworkService.request(target: target) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let tags = try decoder.decode([String].self, from: response.data)
                    success(tags)
                } catch let error {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

}
