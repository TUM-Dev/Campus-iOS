//
//  Dictionary.swift
//  Pods
//
//  Created by Mathias Quintero on 12/5/16.
//
//

import Foundation

public extension Dictionary {
    
    /// Map Only Values
    func mapValues<T>(_ map: @escaping (Value) -> T) -> [Key:T] {
        return self >>= mapLast(with: map)
    }
    
    /**
     Will find a match for in the dictionary by key
     
     - Parameter handler: function that will determine by the key if it's the desired item
     
     - Returns: value found
     */
    func match(_ handler: @escaping (Key) -> Bool) -> Value? {
        return self ==> nil ** { result, item in
            if handler(item.key) {
                return item.value
            } else {
                return result
            }
        }
    }
    
}

public extension Dictionary where Key: CustomStringConvertible {
    
    /**
     Will find a match for in the dictionary by key, checking if 
     the description of the key contains the query
     
     - Parameter handler: query we're looking for in the key
     
     - Returns: value found
     */
    func match(containing query: String) -> Value? {
        return match(describe >>> String.contains ** query)
    }
    
}

public extension Dictionary where Value: Hashable {
    
    /// Returns a flipped mapping of the Dictionary.
    var flipped: [Value:Key] {
        return self >>= flipArguments
    }
    
}

extension Dictionary: Defaultable {
    
    /// Default Value
    public static var defaultValue: [Key:Value] {
        return .empty
    }
    
}

/// TODO: Find a way to inherit from this particular dict
extension Dictionary where Key: CustomStringConvertible, Value: Serializable {
    
    /// JSON Value
    public var json: JSON {
        return .dict(self >>= describe <*> JSON.init)
    }
    
}

public extension ExpressibleByDictionaryLiteral {
    
    static var empty: Self {
        return Self()
    }
    
}
