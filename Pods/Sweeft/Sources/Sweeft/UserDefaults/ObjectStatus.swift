//
//  ObjectStatus.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

/// Wrapper for User Defaults to store an object
public protocol ObjectStatus {
    /// Value type
    associatedtype Value: StatusSerializable
    /// Key type
    associatedtype Key: StatusKey
    
    static var storage: Storage { get }
    /// Key for defaults
    static var key: Key { get }
    /// Default value in case it's not defined
    static var defaultValue: Value { get }
}

public extension ObjectStatus {

    static var storage: Storage {
        return .userDefaults
    }
    
    /// Value in Defaults for your Status
    static var value: Value {
        get {
            return Value.init(from: DictionaryStatus(storage: storage, key: key, defaultValue: .empty).value) ?? defaultValue
        }
        set {
            var status = DictionaryStatus(storage: storage, key: key, defaultValue: .empty)
            status.value = newValue.serialized
        }
    }
    
    /// Reset the value
    static func reset() {
        value = defaultValue
    }
    
}

/// If the value is Defaultable you don't have to specify a default value anymore
public extension ObjectStatus where Value: Defaultable {
    
    static var defaultValue: Value {
        return .defaultValue
    }
    
}

/// Wrapper for User Defaults to store an Array of Objects
public protocol CollectionStatus {
    /// Value type
    associatedtype Value: StatusSerializable
    /// Key type
    associatedtype Key: StatusKey
    
    static var storage: Storage { get }
    /// Key for defaults
    static var key: Key { get }
    /// Default value in case it's not defined
    static var defaultValue: [Value] { get }
    /// Determines if it should fail it at least one of the items isn't deserializable
    static var allOrNothing: Bool { get }
}

public extension CollectionStatus {
    
    static var storage: Storage {
        return .userDefaults
    }
    
    static var values: [Value] {
        get {
            guard let array = SimpleStatus<Key, [[String:Any]]?>(storage: storage, key: key, defaultValue: nil).value else {
                return defaultValue
            }
            let items = array ==> Value.init
            if allOrNothing {
                guard items.count == array.count else {
                    return defaultValue
                }
            }
            return items
        }
        set {
            var status = SimpleStatus<Key, [[String:Any]]?>(storage: storage, key: key, defaultValue: nil)
            status.value = newValue => { $0.serialized }
        }
    }
    
    static var defaultValue: [Value] {
        return .empty
    }
    
    static var allOrNothing: Bool {
        return true
    }
    
}

enum OptionalObjectStatusSerialized<V: StatusSerializable> {
    case none
    case some(value: V)
    
    init(from value: V?) {
        if let value = value {
            self = .some(value: value)
        } else {
            self = .none
        }
    }
    
    var value: V? {
        switch self {
        case .some(let value):
            return value
        default:
            return nil
        }
    }
}

extension OptionalObjectStatusSerialized: StatusSerializable {
    
    init?(from serialized: [String:Any]) {
        guard let value = V.init(from: serialized) else {
            self = .none
            return
        }
        self = .some(value: value)
    }
    
    var serialized: [String : Any] {
        switch self {
        case .some(let value):
            return value.serialized
        default:
            return .empty
        }
    }
    
}

extension OptionalObjectStatusSerialized: Defaultable {
    
    /// Default Value
    static var defaultValue: OptionalObjectStatusSerialized<V> {
        return .none
    }
    
}

/// Wrapper for User Defaults to store an object that can be an optional
public protocol OptionalStatus {
    
    /// Value type
    associatedtype Value: StatusSerializable
    /// Key type
    associatedtype Key: StatusKey
    
    static var storage: Storage { get }
    /// Key for defaults
    static var key: Key { get }
    /// Default value in case it's not defined
    static var defaultValue: Value? { get }
    
}

public extension OptionalStatus {
    
    static var storage: Storage {
        return .userDefaults
    }
    
    static var value: Value? {
        get {
            let value = DictionaryStatus(storage: storage, key: key, defaultValue: .empty).value
            return OptionalObjectStatusSerialized<Value>(from: value)?.value ?? defaultValue
        }
        set {
            var status = DictionaryStatus(storage: storage, key: key, defaultValue: .empty)
            status.value = OptionalObjectStatusSerialized(from: newValue).serialized
        }
    }
    
    static var defaultValue: Value? {
        return nil
    }
    
}
