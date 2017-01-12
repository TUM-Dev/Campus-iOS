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
     Will turn any Collection into a Dictionary with a handler
     
     - Parameter byDividingWith: Mapping function that breaks every element into a key and a value
     
     - Returns: Resulting dictionary
     */
    func dictionaryWithoutOptionals<K, V>(byDividingWith handler: @escaping (Iterator.Element) -> (K, V?)) -> [K:V] {
        return self ==> >{ dict, item in
            var dict = dict
            let (key, value) = handler(item)
            dict[key] <- value
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
     Will check which element best serves your purpose
     
     - Parameter shouldChange: mapper that says whether or not it should change the second element for the first one
     
     - Returns: best match if it exists
     */
    func best(_ shouldChange: @escaping (Iterator.Element, Iterator.Element) -> Bool) -> Iterator.Element? {
        return self.array ==> { prev, next in
            if shouldChange(next, prev) {
                return next
            }
            return prev
        }
    }
    
    /**
     Will check which element best serves your purpose
     
     - Parameter mapping: mapper that translates the value of the element
     - Parameter shouldChange: mapper that says whether or not it should change the second element for the first one
     
     - Returns: best match if it exists
     */
    func best<V>(_ mapping: @escaping (Iterator.Element) -> (V), _ shouldChange: @escaping (V, V) -> Bool) -> Iterator.Element? {
        return best(mapping |>>> shouldChange)
    }
    
    /**
     Will find the minimal item in the collection by using a cost function
     
     - Parameter mapping: Cost function
     
     - Returns: minimal element
     */
    func min<C: Comparable>(_ mapping: @escaping (Iterator.Element) -> (C)) -> Iterator.Element? {
        return best(mapping, (<))
    }
    
    /**
     Will find the maximal item in the collection by using a cost function
     
     - Parameter mapping: Cost function
     
     - Returns: maximal element
     */
    func max<C: Comparable>(_ mapping: @escaping (Iterator.Element) -> (C)) -> Iterator.Element? {
        return best(mapping, (>))
    }
    
    /**
     Will sort by applying a mapping for costs
     
     - Parameter mapping: Cost function
     
     - Returns: sorted array
     */
    func sorted<C: Comparable>(ascending mapping: (Iterator.Element) -> (C)) -> [Iterator.Element] {
        return sorted { mapping($0) < mapping($1) }
    }
    
    /**
     Will sort by applying a mapping and sorting
     
     - Parameter mapping: Cost function
     
     - Returns: sorted array
     */
    func sorted<C: Comparable>(descending mapping: (Iterator.Element) -> (C)) -> [Iterator.Element] {
        return <>sorted(ascending: mapping)
    }
    
}

public extension Collection where Iterator.Element: Hashable {
    
    /// Will turn any Collection into a Set
    var set: Set<Iterator.Element> {
        return Set(array)
    }
    
}

extension Collection where Iterator.Element: Serializable {
    
    public var json: JSON {
        return .array(self => JSON.init)
    }
    
}
