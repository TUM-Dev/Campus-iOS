//
//  Bool.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// Will toggle the value of self
    @discardableResult mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
}

extension Bool: Defaultable {
    
    /// Default Value
    public static let defaultValue = false
    
}

extension Bool: Serializable {
    
    public var json: JSON {
        return .bool(self)
    }
    
}
