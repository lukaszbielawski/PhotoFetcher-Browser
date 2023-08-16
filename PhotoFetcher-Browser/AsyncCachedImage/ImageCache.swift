//
//  ImageCache.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation

class ImageCache {
    typealias Cache = NSCache<NSString, NSData>
    static let shared = ImageCache()
    private init() {}

    private lazy var cache: Cache = {
        let cache = Cache()
        cache.totalCostLimit = 100_000_000
        cache.countLimit = 100
        return cache
    }()

    func object(forkey key: NSString) -> Data? {
        return cache.object(forKey: key) as? Data
    }

    func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
