//
//  Dictionary.swift
//  Pods
//
//  Created by Mathias Quintero on 12/5/16.
//
//

import Foundation

public extension Dictionary {
    
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
        return match {
            return $0.description.contains(query)
        }
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
        return [:]
    }
    
}
