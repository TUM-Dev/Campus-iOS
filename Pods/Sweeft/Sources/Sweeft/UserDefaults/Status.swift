//
//  SimpleStatus.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

/// Wrapper for User Defaults to store a value
public protocol Status {
    /// Valuetype
    associatedtype Value
    /// Keytype
    associatedtype Key: StatusKey
    
    /// Key for defaults
    static var key: Key { get }
    /// Default value in case the value is not defined
    static var defaultValue: Value { get }
}

public extension Status {
    
    /// Value stored in defaults
    static var value: Value {
        get {
            return SimpleStatus(key: key, defaultValue: defaultValue).value
        }
        set {
            var status = SimpleStatus(key: key, defaultValue: defaultValue)
            status.value = newValue
        }
    }
    
    /// Reset the value back to the default
    static func reset() {
        value = defaultValue
    }
    
}
