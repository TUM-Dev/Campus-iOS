//
//  DefaultSaving.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

public enum Storage {
    case userDefaults
    case keychain
    
    var object: StorageItem {
        switch self {
        case .userDefaults:
            return UserDefaults.standard
        default:
            return Keychain()
        }
        
    }
    
}

protocol StorageItem {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: StorageItem { }

protocol StatusFetcher {
    associatedtype Key: StatusKey
    associatedtype Value
    
    var storage: Storage { get }
    var key: Key { get }
    var defaultValue: Value { get }
}

extension StatusFetcher {
    
    var value: Value {
        get {
            return storage.object.object(forKey: key.userDefaultsKey) as? Value ?? defaultValue
        }
        set {
            storage.object.set(newValue, forKey: key.userDefaultsKey)
        }
    }
    
}

struct SimpleStatus<K: StatusKey, V>: StatusFetcher {
    let storage: Storage
    let key: K
    let defaultValue: V
}

typealias DictionaryStatus<V: StatusKey> = SimpleStatus<V, [String:Any]>
