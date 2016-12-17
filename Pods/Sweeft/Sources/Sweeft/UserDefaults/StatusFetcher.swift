//
//  DefaultSaving.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

protocol StatusFetcher {
    associatedtype Key: StatusKey
    associatedtype Value
    
    var key: Key { get }
    var defaultValue: Value { get }
}

extension StatusFetcher {
    
    var value: Value {
        get {
            return UserDefaults.standard.object(forKey: key.userDefaultsKey) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.userDefaultsKey)
        }
    }
    
}

struct SimpleStatus<K: StatusKey, V>: StatusFetcher {
    let key: K
    let defaultValue: V
}

extension SimpleStatus where V: Defaultable {
    
    init(key: K) {
        self.key = key
        self.defaultValue = V.defaultValue
    }
    
}

typealias DictionaryStatus<V: StatusKey> = SimpleStatus<V, [String:Any]>
