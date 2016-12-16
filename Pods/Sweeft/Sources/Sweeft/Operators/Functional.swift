//
//  Functional.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameter value: Item you want to pass
 - Parameter function: Function you want to pass it to
 
 - Returns result of function
 */
public func |<T, V>(_ value: T?, function: ((T) -> V)?) -> V? {
    guard let value = value else {
        return nil
    }
    return function?(value)
}

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameter value: Item you want to pass
 - Parameter function: Function you want to pass it to
 
 - Returns: result of function
 */
public func |<T, V>(_ value: T, function: ((T) -> V)) -> V {
    return function(value)
}

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameter value: Item you want to pass
 - Parameter function: Function you want to pass it to
 
 - Returns: result of function
 */
public func |<T, V>(_ value: T?, function: ((T) -> V)) -> V? {
    guard let value = value else {
        return nil
    }
    return function(value)
}

/**
 nil-check Handler?
 
 - Parameter handler: Closure you want to evaluate
 
 - Returns: a function that will return whether or not the handler evaluates an input to a value or nil
 */
public prefix func ??<T, V>(_ handler: @escaping ((T) -> V?)) -> (T) -> Bool {
    return { ??($0 | handler) }
}

infix operator =>: AdditionPrecedence

/**
 Map
 
 - Parameter items: collection
 - Parameter handler: mapping function
 
 - Returns: result of mapping the array with the function
 */
public func =><C: Collection, V>(_ items: C?, _ handler: (C.Iterator.Element) -> (V)) -> [V] {
    return (items?.map(handler)).?
}

/**
 Map With Index
 
 - Parameter items: array
 - Parameter handler: mapping function
 
 - Returns: result of mapping the array with the function
 */
public func =><T, V>(_ items: [T]?, _ handler: (T, Int) -> (V)) -> [V] {
    return (items?.map(handler)).?
}


/**
 For each from number
 
 - Parameter number: number of times the loop should run
 - Parameter handler: loop code
 
 */
public func =><V>(_ number: Int?, _ handler: @escaping () -> (V)) {
    number?.times(do: handler)
}

/**
 For each from number
 
 - Parameter number: number of times the loop should run
 - Parameter handler: loop code
 
 */
public func =><V>(_ number: Int?, _ handler: @escaping (Int) -> (V)) {
    number?.times(do: handler)
}

/**
 For each. Will call the handler with every element in the array
 
 - Parameter items: array
 - Parameter handler: mapping function
 
 */
public func =><C: Collection>(_ items: C?, _ handler: (C.Iterator.Element) -> ()) {
    items?.forEach(handler)
}

/**
 For each with index. Will call the handler with every element in the array
 
 - Parameter items: array
 - Parameter handler: mapping function
 
 */
public func =><T>(_ items: [T]?, _ handler: (T, Int) -> ()) {
    items?.forEach(handler)
}

/**
 Empty for each
 
 - Parameter items: array
 - Parameter handler: call that should be called
 
 */
//public func =><C: Collection>(_ items: C?, _ handler: @escaping () -> ()) {
//    items?.forEach(**handler)
//}

infix operator ==>: AdditionPrecedence

/**
 FlatMap
 
 - Parameters:
    - items: collection
    - handler: mapping function
 
 - Returns: result of flatMapping the collection with the function
 */
public func ==><C: Collection, V>(_ items: C?, _ handler: (C.Iterator.Element) -> (V?)) -> [V] {
    return (items?.flatMap(handler)).?
}

/**
 Reduce
 
 - Parameter items: collection
 - Parameter handler: next partial result function
 
 - Returns: result of reduce
 */
public func ==><T>(_ items: [T]?, _ handler: @escaping (T, T) -> (T)) -> T? {
    return items?.reduce(handler)
}

/**
 Reduce with index
 
 - Parameter items: array
 - Parameter handler: next partial result function with index
 
 - Returns: result of reduce
 */
public func ==><T>(_ items: [T]?, _ handler: @escaping (T, T, Int) -> (T)) -> T? {
    return items?.reduce(handler)
}

infix operator |>: AdditionPrecedence

/**
 Filter
 
 - Parameter items: collection
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func |><C: Collection>(_ items: C?, _ handler: (C.Iterator.Element) -> Bool) -> [C.Iterator.Element] {
    return (items?.filter(handler)).?
}

/**
 Filter with index
 
 - Parameter items: array
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V]?, _ handler: (V, Int) -> Bool) -> [V] {
    return (items?.filter(handler)).?
}

/**
 Filter
 
 - Parameter items: collection
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func |><C: Collection>(_ items: C?, _ handler: @escaping (C.Iterator.Element) -> Bool?) -> [C.Iterator.Element] {
    return items |> handler.?
}

/**
 Filter with index
 
 - Parameter items: array
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V]?, _ handler: @escaping (V, Int) -> Bool?) -> [V] {
    return items |> handler.?
}

infix operator !|>: AdditionPrecedence

/**
 Anti-Filter
 
 - Parameter items: collection
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func !|><C: Collection>(_ items: C?, _ handler: (C.Iterator.Element) -> Bool) -> [C.Iterator.Element] {
    return items |> { !handler($0) }
}

/**
 Anti-Filter with index
 
 - Parameter items: array
 - Parameter handler: includes function
 
 - Returns: filtered array
 */
public func !|><V>(_ items: [V]?, _ handler: (V, Int) -> Bool) -> [V] {
    return items |> { !handler($0, $1) }
}

/**
 Dictionary
 
 - Parameter items: collection
 - Parameter handler: dividing function
 
 - Returns: dictionary
 */
public func >>=<C: Collection, K, V>(_ items: C?, _ handler: @escaping (C.Iterator.Element) -> (K, V)) -> [K:V] {
    return (items?.dictionary(byDividingWith: handler)).?
}

/**
 Dictionary with index
 
 - Parameter items: array
 - Parameter handler: dividing function with index
 
 - Returns: dictionary
 */
public func >>=<T, K, V>(_ items: [T], _ handler: @escaping (T, Int) -> (K, V)) -> [K:V] {
    return items.dictionary(byDividingWith: handler)
}

prefix operator **

/**
 Ignore input
 
 - Parameter handler: function without input
 
 - Returns: function that can take an input and drop it to call the handler.
 */
public prefix func **<T, V>(_ handler: @escaping () -> (V)) -> (T) -> (V) {
    return dropArguments >>> handler
}

postfix operator **

/**
 Ignore ouput
 
 - Parameter handler: function with output
 
 - Returns: function that will evaluate the handler but won't return its value
 */
public postfix func **<T, V>(_ handler: @escaping (T) -> (V)) -> (T) -> () {
    return handler >>> dropArguments
}

/**
 Defaultable output Handler
 
 - Parameter handler: Closure you want to evaluate
 
 - Returns: a function that will return the handlers return value or the default value of the return type on nil
 */
public postfix func .?<T, V: Defaultable>(_ handler: @escaping ((T) -> V?)) -> (T) -> V {
    return { ($0 | handler).? }
}

prefix operator .?

/**
 Defaultable input Handler
 
 - Parameter handler: Closure you want to evaluate
 
 - Returns: a function that will feed the handler the input or the default of the type in case of nil
 */
public prefix func .?<T: Defaultable, V>(_ handler: @escaping (T) -> (V)) -> (T?) -> V {
    return { $0.? | handler }
}

/**
 Optionalize
 
 - Parameter handler: function that requires non-optionals
 
 - Returns: function that can take an optioanl and will return nil in case the input is nil
 */
public prefix func !<T, V>(_ handler: @escaping (T) -> (V)) -> (T?) -> (V?) {
    return { $0 | handler }
}

postfix operator .!

/**
 Force Unwrap function result
 
 - Parameter handler: function that return an optional
 
 - Returns: function that will unwrap the result of the first function
 */
public postfix func .!<T, V>(_ handler: @escaping (T) -> (V?)) -> (T) -> (V) {
    return { ($0 | handler)! }
}

/**
 Or For Handlers
 
 - Parameter handlerOne: function that returns a boolean
 - Parameter handlerTwo: function that returns a boolen
 
 - Returns: function that will apply logical or to both results
 */
public func ||<K>(_ handlerOne: @escaping (K) -> Bool, _ handlerTwo: @escaping (K) -> Bool) -> (K) -> Bool {
    return { handlerOne($0) || handlerTwo($0) }
}

/**
 And For Handlers
 
 - Parameter handlerOne: function that returns a boolean
 - Parameter handlerTwo: function that returns a boolen
 
 - Returns: function that will apply logical and to both results
 */
public func &&<K>(_ handlerOne: @escaping (K) -> Bool, _ handlerTwo: @escaping (K) -> Bool) -> (K) -> Bool {
    return { handlerOne($0) && handlerTwo($0) }
}

infix operator &&>

/**
 Will evaluate the concatenation of all the Elements in a Collection into a single Bool
 
 - Parameter items: Collection
 - Parameter handler: mapper that says if an Element should evaluate to true or false
 
 - Returns: result of concatenation
 */
public func &&><C: Collection>(_ items: C?, _ handler: (C.Iterator.Element) -> Bool) -> Bool {
    return (items?.and(conjunctUsing: handler)) ?? true
}

infix operator ||>

/**
 Will evaluate the disjunct of all the Elements in a Collection into a single Bool
 
 - Parameter items: Collection
 - Parameter handler: mapper that says if an Element should evaluate to true or false
 
 - Returns: result of disjunction
 */
public func ||><C: Collection>(_ items: C?, _ handler: (C.Iterator.Element) -> Bool) -> Bool {
    return (items?.or(disjunctUsing: handler)).?
}
