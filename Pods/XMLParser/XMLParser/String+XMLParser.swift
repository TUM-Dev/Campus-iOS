//
//  String+XMLParser.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A convenience extension for parsing a string into an XML structure.
public extension String {
    /// XML begin tag (e.g. `<request>`).
    public func startHeader() -> String {
        if !hasPrefix("<") && !hasSuffix(">") {
            return "<\(self)>"
        }
        
        return self
    }
    
    /// XML end tag (e.g. `</request>`).
    public func endHeader() -> String {
        if !hasPrefix("<") && !hasSuffix(">") {
            return "</\(self)>"
        }
        
        return self
    }
    
    /// XML tag value (e.g. from `<request>` the result is 'request').
    public func original() -> String {
        var start = startIndex
        var end = endIndex
        
        if hasPrefix("<") {
            start++
            
            if self[start..<endIndex].hasPrefix("/") {
                start++
            }
            
        }
        
        if hasSuffix(">") {
            end--
        }
        
        return self[start..<end]
    }
}