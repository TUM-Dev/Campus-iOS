//
//  XMLParser.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A parser class supposed to provide features for (de)coding 
/// data into XML and vice versa.
/// The class provides a singleton.
public class XMLParser: XMLCoder, XMLDecoder {
    /// A singleton accessor.
    public static let sharedParser = XMLParser()
    
    // MARK: - XMLCoder & XMLDecoder
    
    public func encode<Key : Hashable, Value>(data: Dictionary<Key, Value>, header: String = "") -> String {
        guard let tries = data.generateTries() else {
            return ""
        }
        
        return header + tries.map { $0.parsedRequestBody() }.reduce("", combine: +)
    }
    
    public func decode(data: String) -> Dictionary<String, [String]> {
        return findTags(data)
    }
    
    // MARK: - Initialization 
    
    /// A private initializer for singleton implementation.
    private init() { }
    
    // MARK: - Utils
    
    /// Finds XML tags in a given string (supposed to be previously parsed into XML format). 
    /// - parameter body: A given XML parsed string. 
    /// - returns: A dictionary with arrays of values.
    private func findTags(body: String) -> [String : [String]] {
        var keys: [String] = []
        
        var write = false
        var char = ""
        var value = ""
        var values: [String : [String]] = [:]
        
        for ch in body.characters {
            if ch == "<" {
                write = true
            } else if ch == ">" {
                write = false
            }
            
            if ch == "\n" {
                continue
            }
            
            if write {
                if let last = keys.last where value != "" {
                    if let _ = values[last.original()] {
                        values[last.original()]! += [value]
                    } else {
                        values[last.original()] = []
                        values[last.original()]! += [value]
                    }
                    value = ""
                }
                
                char += String(ch)
            } else {
                if char != "" {
                    char += String(ch)
                    keys += [char]
                    char = ""
                } else if let last = keys.last where last == last.original().startHeader() {
                    if ch == " " && (value.characters.last == " " || value.characters.last == "\n" || value.characters.count == 0)  {
                        continue
                    }
                    
                    value += String(ch)
                }
            }
        }
        
        return values
    }
    
}
