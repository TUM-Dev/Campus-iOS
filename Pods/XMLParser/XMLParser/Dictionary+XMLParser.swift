//
//  Dictionary+XMLParser.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A convenience extension for assembling tries from
/// a dictionary with values (XML representation).
public extension Dictionary {
    
    // MARK: - Initialization
    
    /// Merges current dictionary with a given dictionary.
    public mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(sequence: S) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
    
    /// An initializer for merging two dictionaries.
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(sequence: S) {
        self.init()
        merge(sequence)
    }
    
    /// An initializer for merging current dictionary and pairs ([Key, Value]).
    public init(pairs: [(Key, Value)]) {
        self.init()
        merge(pairs)
    }
    
    /// Creates pairs (Key,Value) from the dictionary.
    private func pairs(var tree: [Dictionary<Key, Value>] = [[:]]) -> (keys: [Key], values: [Value]) {
        if tree.isEmpty {
            tree = dictionariesTree()
        }
        
        var keys: Set<Key> = []
        var values: [Value] = []
        
        for dict in tree {
            for (key, value) in dict {
                keys.insert(key)
                
                if !collection(values, hasElement: value) {
                    values += [value]
                }
            }
        }
        
        return (keys.map { $0 }, values)
    }
    
    /// Converts an NSDictionary into a pure Swift Dictionary with generic 
    /// Key, Value pair.
    public static func convertedDictionary<K: Hashable, V>(dictionary: NSDictionary) -> Dictionary<K, V> {
        var dict = Dictionary<K, V>()
        for (key, value) in dictionary {
            if let key = key as? K, value = value as? V {
                dict[key] = value
            }
        }
        
        return dict
    }
    
    /// An initializer for creating a pure Swift Dictionary
    /// from Cocoa NSDictionary analogue.
    public init(dictionary: NSDictionary) {
        let pairs = dictionary.map { ($0.key as? Key, $0.value as? Value) }
        let prepared = pairs.filter { ($0.0 != nil && $0.1 != nil) }
        self.init(pairs: prepared as! [(Key, Value)])
    }
    
    /// Returns a Cocoa NSDictionary from the pure Swift Dictionary.
    public func standardDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        for (k, v) in self {
            if let key = k as? NSCopying, value = v as? AnyObject {
                dict[key] = value
            }
        }
        
        return dict
    }
    
    // MARK: - Assembling tries
    
    /// Assembles a general tree for the given dictionary.
    public func dictionariesTree() -> [Dictionary<Key, Value>] {
        var collections: Set<NSDictionary> = []
        collections.insert(self.standardDictionary())
        
        func iterate(dictionary: Dictionary<Key, Any>) {
            for (_, value) in dictionary {
                if let dict = value as? NSDictionary where !collections.contains(dict) {
                    collections.insert(dict)
                    iterate(Dictionary.convertedDictionary(dict) as Dictionary<Key, Any>)
                }
            }
        }
        
        iterate(Dictionary.convertedDictionary(self.standardDictionary()) as Dictionary<Key, Any>)
        
        return collections.map { Dictionary(dictionary: $0) }
    }
    
    /// Determines if an array with this dictionary's values contains one.
    private func collection(values: [Value], hasElement value: Value) -> Bool {
        let contains = values.contains { (element: Value) in
            return self.value(value, equalToValue: element)
        }
        
        return contains
    }
    
    /// Equatable analogue.
    private func value(value: Value, equalToValue other: Value) -> Bool {
        if let value = value as? NSNumber, other = other as? NSNumber {
            return value == other
        } else if let value = value as? NSValue, other = other as? NSValue {
            return value == other
        }
        
        return false
    }
    
    // TODO: Fix for parsing arrays as well
    
    /// Create an array of tries (for high level tags).
    public func generateTries() -> [Tree<Any>]? {
        var collections: Set<NSDictionary> = []
        var chains: [Tree<Any>] = []
        
        collections.insert(self.standardDictionary())
        
        func iterate(dictionary: Dictionary<Key, Any>, lastChain: Tree<Any>?) {
            for (key, value) in dictionary {
                let chain = Tree<Any>(previous: lastChain, node: ("\(key)", "\(value)"), next: nil)
                chains += [chain]
                
                if let lastChain = lastChain {
                    if lastChain.next == nil {
                        lastChain.next = []
                    }
                    
                    lastChain.next! += [chain]
                }
                
                if let dict = value as? NSDictionary where !collections.contains(dict) {
                    collections.insert(dict)
                    iterate(Dictionary.convertedDictionary(dict) as Dictionary<Key, Any>, lastChain: chain)
                }
            }
        }
        
        iterate(Dictionary.convertedDictionary(self.standardDictionary()) as Dictionary<Key, Any>, lastChain: nil)
        
        chains = chains.filter { $0.first() == $0 }
        
        return chains
    }
}