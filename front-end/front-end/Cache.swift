//
//  Cache.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/18/23.
//

import Foundation


// objects in the cache have the following format

// method-body-route for stuff obtained via http request
// className-lessonName for stuff obtained via s3

class Cache: ObservableObject{
    
    static let instance = Cache()
    private init() {}
    
    var cache:  NSCache<NSString, CacheableData> = {
        let cache = NSCache<NSString, CacheableData>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func add(name: String, data: CacheableData){
        cache.setObject(data, forKey: name as NSString)
    }
    
    func remove(name: String){
        cache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) -> CacheableData? {
        return cache.object(forKey: name as NSString)
    }
}

// this is a wrapper around data because NSCache requires a class
class CacheableData {
    let data: Data

    init(_ data: Data) {
        self.data = data
    }
}
