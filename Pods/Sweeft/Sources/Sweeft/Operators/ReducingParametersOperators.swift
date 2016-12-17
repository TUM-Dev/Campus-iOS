//
//  ReducingParametersOperators.swift
//  Pods
//
//  Created by Mathias Quintero on 12/7/16.
//
//

import Foundation

/**
 Creates a Reducing Parameter
 
 - Parameters:
    - nextPartialResult: nextPartialResult Handler for reduce
    - initialResult: initial result for reduce
 
 - Returns: Reducing Parameter
 */
public func **<P: ReducingParameters>(_ nextPartialResult: P.NextPartialResultHandler, _ initialResult: P.Result) -> P {
    return P(initialResult: initialResult, nextPartialResult: nextPartialResult)
}

/**
 Creates a Reducing Parameter
 
 - Parameter initialResult: initial result for reduce
 - Parameter nextPartialResult: nextPartialResult Handler for reduce
 
 - Returns: Reducing Parameter
 */
public func **<P: ReducingParameters>(_ initialResult: P.Result, _ nextPartialResult: P.NextPartialResultHandler) -> P {
    return nextPartialResult ** initialResult
}

/**
 Reduce
 
 - Parameter items: collection
 - Parameter reducingParameters: Reducing Parameters
 
 - Returns: Result of reduce
 */
public func ==><C: Collection, R>(_ items: C, _ reducingParameters: RegularReducingParameters<C.Iterator.Element, R>) -> R {
    return items.reduce(reducingParameters.initialResult, reducingParameters.nextPartialResult)
}

/**
 Reduce with index
 
 - Parameter items: collection
 - Parameter reducingParameters: Reducing Parameters with index
 
 - Returns: Result of reduce
 */
public func ==><I, R>(_ items: [I], _ reducingParameters: ReducingParametersWithIndex<I, R>) -> R {
    return items.reduce(reducingParameters.initialResult, reducingParameters.nextPartialResult)
}

prefix operator >

/**
 Default Reducing Parameters. Creates them with the default value for the type of the result
 
 - Parameter nextPartialResult: nextPartialResult Handler for reduce
 
 - Returns: Result of reduce
 */
public prefix func ><P: ReducingParameters where P.Result: Defaultable>(_ nextPartialResult: P.NextPartialResultHandler) -> P {
    return P.Result.defaultValue ** nextPartialResult
}
