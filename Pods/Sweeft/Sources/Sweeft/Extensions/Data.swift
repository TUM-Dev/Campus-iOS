//
//  Data.swift
//  Pods
//
//  Created by Mathias Quintero on 12/12/16.
//
//

import Foundation

public extension Data {
    
    /// String using the utf8 encoding format
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
}

extension Data: Defaultable {
    
    /// Default value is an empty set of data
    public static var defaultValue: Data {
        return Data()
    }
    
}
