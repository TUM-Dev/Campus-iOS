//
//  XMLCoder.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A protocol for encoding a dictionary with values into an XML string.
public protocol XMLCoder {
    /// Encodes a dictionary into an XML string. 
    /// - parameter data: A generic dictionary. Generally, the **Key** should be hashable and
    /// in most of cases it must be a **String**. The value 
    /// might vary. 
    /// - parameter header: A header for the XML string.
    /// - returns: A converted XML string.
    func encode<Key: Hashable, Value>(data: Dictionary<Key, Value>, header: String) -> String
}