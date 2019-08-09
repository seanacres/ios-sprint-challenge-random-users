//
//  Cache.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedItems: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems.updateValue(value, forKey: key)
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync(execute: {
            cachedItems[key]
        })
    }
}
