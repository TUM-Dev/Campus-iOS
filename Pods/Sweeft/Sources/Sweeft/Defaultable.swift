//
//  Defaultable.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

/// A Type with a Default Value
public protocol Defaultable {
    
    /// Default Value for Type
    static var defaultValue: Self { get }
}

public extension Defaultable {
    
    /// Will return an empty array
    static var array: [Self] {
        return array()
    }
    
    /**
     Will generate an array populated with default values
     
     - Parameter size: size of the array. (Default: 0)
     */
    static func array(of size: Int = 0) -> [Self] {
        return defaultValue.array(of: size)
    }
    
    /**
     Will generate an array populated with the same value
     
     - Parameter size: size of the array. (Default: 0)
     */
    func array(of size: Int = 0) -> [Self] {
        return size.range => returning(self)
    }
    
}
