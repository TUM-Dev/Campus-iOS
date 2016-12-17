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
