//
//  Other.swift
//  Pods
//
//  Created by Mathias Quintero on 12/9/16.
//
//

import Foundation

/**
 Will return whatever you give it. Useful to replace '{ $0 }' and make the code more approachable and friendly ;)
 
 - Parameter value: value
 
 - Returns: value
 */
public func id<T>(_ value: T) -> T {
    return value
}

/**
 Will turn a value into a closure that always returns said value.
 
 - Parameter value: value
 
 - Returns: Closure that returns that value regardless of the input
 */
public func returning<T, V>(_ value: V) -> (T) -> V {
    return **{ value }
}

/**
 Will return the first argument you give it. Let type inference do what you need it to do. 
 (Be careful with type inference)
 
 - Parameter argOne: value
 - Parameter argTwo: value you want to ignore
 
 - Returns: argOne
 */
public func firstArgument<T, V>(_ argOne: T, _ argTwo: V) -> T {
    return argOne
}

/**
 Will return the last argument you give it. Let type inference do what you need it to do.
 (Be careful with type inference)
 
 - Parameter argOne: value you want to ignore
 - Parameter argTwo: value
 
 - Returns: argTwo
 */
public func lastArgument<T, V>(_ argOne: T, _ argTwo: V) -> V {
    return argTwo
}

/**
 Will return the middle argument you give it. Let type inference do what you need it to do.
 (Be careful with type inference. Really careful with this one!!!)
 
 - Parameter argOne: value you want to ignore
 - Parameter argTwo: value
 - Parameter argThree: value you want to ignore
 
 - Returns: argTwo
 */
public func middleArgument<T, V, Z>(_ argOne: T, _ argTwo: V, _ argThree: Z) -> V {
    return argTwo
}

/**
 Will map any input into by adding more input to it
 
 - Parameter argument: value you want to append to the input
 
 - Returns: function that passes the input through with the extra argument at the end
 */
public func add<V, T>(trailing argument: T) -> (V) -> (V, T) {
    return id <+> returning(argument)
}

/**
 Will map any input into by adding more input to it
 
 - Parameter argument: value you want to append to the input
 
 - Returns: function that passes the input through with the extra argument at the start
 */
public func add<V, T>(starting argument: T) -> (V) -> (T, V) {
    return add(trailing: argument) >>> flipArguments
}

/**
 Will map a partial part of the input and compile it again into an output
 
 - Parameter partial: gives the part of the input that should be mapped
 - Parameter map: Maps the part to another value
 - Parameter cleanup: compiles the original value with the new output to a new value
 
 - Returns: mapping function
 */
public func partialMap<V, T, O, R>(partial: @escaping (V) -> (T), map: @escaping (T) -> (O), cleanup: @escaping (V, O) -> R) -> (V) -> (R) {
    return { $0 | partial >>> map >>> add(starting: $0) >>> cleanup }
}

/**
 Will map the first argument and leave the rest intact
 
 - Parameter map: Maps the part to another value
 
 - Returns: mapping function
 */
public func mapFirst<V, T, R>(with map: @escaping (V) -> (R)) -> (V, T) -> (R, T) {
    return map <*> id
}

/**
 Will map the last argument and leave the rest intact
 
 - Parameter map: Maps the part to another value
 
 - Returns: mapping function
 */
public func mapLast<V, T, R>(with map: @escaping (T) -> (R)) -> (V, T) -> (V, R) {
    return id <*> map
}

/**
 Will map the middle argument and leave the rest intact.
 Be careful. Type inference will try to figure things out, but if it can't do something else.
 
 - Parameter map: Maps the part to another value
 
 - Returns: mapping function
 */
public func mapMiddle<V, T, O, R>(with map: @escaping (T) -> (R)) -> (V, T, O) -> (V, R, O) {
    return partialMap(partial: middleArgument, map: map) { ($0.0, $1, $0.2) }
}

/**
 Will map two inputs
 
 - Parameter map: Maps the values to the results
 
 - Returns: mapping function
 */
public func mapBoth<V, R>(with map: @escaping (V) -> (R)) -> (V, V) -> (R, R) {
    return map <*> map
}

/**
 Will create a function that will get a function and apply the value to it
 
 - Parameter value: Value that should be applied to inputed function
 
 - Returns: function that takes a function and returns the result
 */
public func apply<T, V>(value: V) -> ((V) -> (T)) -> T {
    return { value | $0 }
}

/**
 Will drop any arguments given to it. Who knows? Might be useful.
 
 - Parameter value: value
 */
public func dropArguments<V>(_ input: V) {  }

/**
 Fill filp the order of the arguments
 
 - Parameter argOne: value
 - Parameter argTwo: value
 
 - Returns: argTwo, argOne
 */
public func flipArguments<T, V>(_ argOne: T, _ argTwo: V) -> (V, T) {
    return (argTwo, argOne)
}

/**
 Will return the arguments twice
 
 - Parameter arguments: value
 
 - Returns: Tuple containing the arguments twice
 */
public func duplicateArguments<V>(_ arguments: V) -> (V, V) {
    return (arguments, arguments)
}

/**
 Will deoptionalize the internal optionals
 
 - Parameter a: value
 - Parameter b: value
 
 - Returns: a, b only if both have values, nil otherwise
 */
public func iff<A, B>(first a: A?, and b: B?) -> (A, B)? {
    guard let a = a, let b = b else {
        return nil
    }
    return (a, b)
}

/**
 Will increase the input by one. Can also be written as (+) ** 1
 
 - Parameter number: n
 
 - Returns: n + 1
 */
public func inc(_ number: Int) -> Int {
    return number + 1
}

/**
 Will deliver the negative of a number
 
 - Parameter number: n
 
 - Returns: n * (-1)
 */
public func negative(_ number: Int) -> Int {
    return -number
}

/**
 Will return the description of any input
 
 - Parameter input: String convertible item
 
 - Returns: String representation
 */
public func describe<T: CustomStringConvertible>(of input: T) -> String {
    return input.description
}

/**
 Will split a function with two outputs into two functions with a single output each. Is supposed to be the inverse equivalent of <+>
 **Be careful no to include a state into these closures. Since they might be run more than once.**
 
 - Parameter handler: closure that you want to split
 
 - Returns: Tuple of clousures
 */
public func divide<A, B, C>(closure handler: @escaping (A) -> (B, C)) -> ((A) -> B, (A) -> C) {
    return (handler >>> firstArgument, handler >>> lastArgument)
}
