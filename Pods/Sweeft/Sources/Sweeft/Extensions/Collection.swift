//
//  Collection.swift
//  Pods
//
//  Created by Mathias Quintero on 12/5/16.
//
//

import Foundation

public extension Collection {
    
    /// Will Turn any Collection into an Array for easier handling
    var array: [Iterator.Element] {
        return self => id
    }
    
    /// Return a random item in the collection
    var random: Iterator.Element? {
        return array | Int(arc4random()) % array.count
    }
    
    /**
     Will turn any Collection into a Dictionary with a handler
     
     - Parameter byDividingWith: Mapping function that breaks every element into a key and a value
     
     - Returns: Resulting dictionary
     */
    func dictionary<K, V>(byDividingWith handler: @escaping (Iterator.Element) -> (K, V)) -> [K:V] {
        return self ==> >{ dict, item in
            var dict = dict
            let (key, value) = handler(item)
            dict[key] = value
            return dict
        }
    }
    
    /**
     Will sum all of the Elements
     
     - Parameter mapper: Mapping function that returns the value for an Element
     
     - Returns: Result of sum
     */
    func sum(_ mapper: (Iterator.Element) -> (Double)) -> Double {
        return self => mapper ==> >(+)
    }
    
    /**
     Will sum all of the Elements
     
     - Parameter mapper: Mapping function that returns the value for an Element
     
     - Returns: Result of sum
     */
    func sum(_ mapper: (Iterator.Element) -> (Int)) -> Int {
        return Int(sum(mapper))
    }
    
    /**
     Will multiply all of the Elements
     
     - Parameter mapper: Mapping function that returns the value for an Element
     
     - Returns: Result of multiplication
     */
    func multiply(_ mapper: (Iterator.Element) -> (Double)) -> Double {
        return self => mapper ==> (*) ?? 1
    }
    
    /**
     Will multiply all of the Elements
     
     - Parameter mapper: Mapping function that returns the value for an Element
     
     - Returns: Result of multiplication
     */
    func multiply(_ mapper: (Iterator.Element) -> (Int)) -> Int {
        return Int(multiply(mapper))
    }
    
    /**
     Will join the elements as a single string
     
     - Parameter with string: string that should go between the individual entries (Default: separating by comma)
     - Parameter by mapping: mapping function that turns each Element into a string (Default: String description of Element)
     
     - Returns: String result
     */
    func join(with string: String = ", ", by mapping: (Iterator.Element) -> (String) = { "\($0)" }) -> String {
        let joined = self => mapping ==> { "\($0)\(string)\($1)" }
        return joined.?
    }
    
    /**
     Will evaluate the concatenation of all the Elements into a single Bool
     
     - Parameter mapping: mapper that says if an Element should evaluate to true or false
     
     - Returns: result of concatenation
     */
    func and(conjunctUsing mapping: (Iterator.Element) -> Bool) -> Bool {
        return self => mapping ==> true ** { $0 && $1 }
    }
    
    /**
     Will evaluate the disjunction of all the Elements into a single Bool
     
     - Parameter mapping: mapper that says if an Element should evaluate to true or false
     
     - Returns: result of disjunction
     */
    func or(disjunctUsing mapping: (Iterator.Element) -> Bool) -> Bool {
        return !and { !mapping($0) }
    }
    
    /**
     Will find the minimal item in the collection by using a cost function
     
     - Parameter mapping: Cost function
     
     - Returns: minimal element
     */
    func min(_ mapping: @escaping (Iterator.Element) -> (Double)) -> Iterator.Element? {
        let array = self.array
        return array ==> { prev, next in
            if mapping(next) < mapping(prev) {
                return next
            }
            return prev
        }
    }
    
    /**
     Will find the maximal item in the collection by using a cost function
     
     - Parameter mapping: Cost function
     
     - Returns: maximal element
     */
    func max(_ mapping: @escaping (Iterator.Element) -> (Double)) -> Iterator.Element? {
        return min { -mapping($0) }
    }
    
}

public extension Collection where Iterator.Element: Hashable {
    
    /// Will turn any Collection into a Set
    var set: Set<Iterator.Element> {
        return Set(array)
    }
    
}
