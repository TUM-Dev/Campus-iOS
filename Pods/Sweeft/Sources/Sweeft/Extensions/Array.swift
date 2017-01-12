//
//  Arrays.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Array with Elements and indexes for better for loops.
    var withIndex: [(element: Element, index: Int)] {
        return count.range => { (self[$0], $0) }
    }
    
    /// Random index contained in the array
    var randomIndex: Int? {
        return count.range?.random
    }
    
    /**
     Map with index
     
     - Parameter transform: tranform function with index
     
     - Returns: transformed array
     */
    func map<T>(_ transform: (Element, Int) -> T) -> [T] {
        return withIndex => transform
    }
    
    /**
     For each with index
     
     - Parameter body: body function with index
     */
    func forEach(_ body: (Element, Int) -> Void) {
        withIndex => body
    }
    
    /**
     Filter with index
     
     - Parameter isIncluded: isIncluded function with index
     
     - Returns: filtered array
     */
    func filter(_ isIncluded: (Element, Int) -> Bool) -> [Element] {
        return withIndex |> isIncluded => firstArgument
    }
    
    /**
     Reduce with index
     
     - Parameter initialResult: Accumulator
     - Parameter nextPartialResult: resulthandler with index
     
     - Returns: Result
     */
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: @escaping (Result, Element, Int) -> Result) -> Result {
        return withIndex ==> initialResult ** { nextPartialResult($0, $1.0, $1.1) }
    }
    
    /**
     Reduce with first item as partial result
     
     - Parameter nextPartialResult: resulthandler
     
     - Returns: Result
     */
    func reduce(_ nextPartialResult: @escaping (Element, Element) -> Element) -> Element? {
        guard let first = first else {
            return nil
        }
        return array(withLast: count - 1) ==> first ** nextPartialResult
    }
    
    /**
     Reduce with first item as partial result and with index
     
     - Parameter nextPartialResult: resulthandler with index
     
     - Returns: Result
     */
    func reduce(_ nextPartialResult: @escaping (Element, Element, Int) -> Element) -> Element? {
        guard let first = first else {
            return nil
        }
        return array(withLast: count - 1) ==> first ** nextPartialResult
    }
    
    /**
     Will turn any Array into a Dictionary with a handler
     
     - Parameter byDividingWith: Mapping function that breaks every element into a key and a value with index
     
     - Returns: Resulting dictionary
     */
    func dictionary<K, V>(byDividingWith handler: @escaping (Element, Int) -> (K, V)) -> [K:V] {
        return withIndex.dictionary(byDividingWith: handler)
    }
    
    /**
     Will give you the first n Elements of an Array
     
     - Parameter withFirst number: Number of items you want
     
     - Returns: Array with the first n Elements
     */
    func array(withFirst number: Int) -> [Element] {
        if number > count {
            return self
        }
        return number.range => { self[$0] }
    }
    
    /**
     Will give you the last n Elements of an Array
     
     - Parameter withFirst number: Number of items you want
     
     - Returns: Array with the last n Elements
     */
    func array(withLast number: Int) -> [Element] {
        return <>(<>self).array(withFirst: number)
    }
    
    /**
     Will shift the index of an item to another inced
     
     - Parameter source: index of the item you want to move
     - Parameter destination: index where you want it to be at
     */
    mutating func move(itemAt source: Int, to destination: Int) {
        let element = self[source]
        remove(at: source)
        insert(element, at: destination)
    }
    
    /**
     Will shift the index of an item to another inced
     
     - Parameter source: index of the item you want to move
     - Parameter destination: index where you want it to be at
     
     - Returns: Resulting array
     */
    func moving(from source: Int, to destination: Int) -> [Element] {
        var copy = self
        copy.move(itemAt: source, to: destination)
        return copy
    }
    
    /**
     Will shuffle the contents of an array
     
     - Returns: shuffled copy
     */
    func shuffled() -> [Element] {
        guard !isEmpty else { return self }
        var array = self
        let swaps = randomIndex.? + 10
        swaps => {
            let a = (self.randomIndex).?
            let b = (self.randomIndex).?
            if a != b {
                array[a] <=> array[b]
            }
        }
        return array
    }
    
    /**
     Will shuffle the contents of an array in-place
     
     */
    mutating func shuffle() {
        self = shuffled()
    }
    
}

public extension Array where Element: Hashable {
    
    /// Checks if it has duplicates
    var hasDuplicates: Bool {
        return noDuplicates.count != count
    }
    
    /// Array without the duplicates
    var noDuplicates: [Element] {
        return set.array
    }
    
}

extension Array: Defaultable {
    
    /// Default Value
    public static var defaultValue: [Element] {
        return []
    }
    
}
