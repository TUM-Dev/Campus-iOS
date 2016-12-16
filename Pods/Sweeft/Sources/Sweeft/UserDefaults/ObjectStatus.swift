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
    
    /// Key for defaults
    static var key: Key { get }
    /// Default value in case it's not defined
    static var defaultValue: Value { get }
}

public extension ObjectStatus {

    /// Value in Defaults for your Status
    static var value: Value {
        get {
            return Value.init(from: DictionaryStatus(key: key).value) ?? defaultValue
        }
        set {
            var status = DictionaryStatus(key: key)
            status.value = newValue.serialized
        }
    }
    
    /// Reset the value
    static func reset() {
        value = defaultValue
    }
    
}
