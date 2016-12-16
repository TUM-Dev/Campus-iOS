
//
//  ReducingParameters.swift
//  Pods
//
//  Created by Mathias Quintero on 12/7/16.
//
//

import Foundation

/// Wrapper for parameters in reduce
public protocol ReducingParameters {
    
    /// Input of the collection
    associatedtype Input
    /// Result of the reducing function
    associatedtype Result
    /// Format of the nextPartialResult handler
    associatedtype NextPartialResultHandler
    
    /// Initial value given to the result
    var initialResult: Result { get }
    /// Reducing function
    var nextPartialResult: NextPartialResultHandler { get }
    
    
    /// Initializer
    init(initialResult: Result, nextPartialResult: NextPartialResultHandler)
}

/// Wrapper for the regular reduce
public struct RegularReducingParameters<I, R>: ReducingParameters {
    
    public typealias Input = I
    /// Result of the reducing function
    public typealias Result = R
    /// Format of the nextPartialResult handler
    public typealias NextPartialResultHandler = (Result, Input) -> (Result)
    
    /// Initial value given to the result
    public let initialResult: Result
    /// Reducing function
    public let nextPartialResult: NextPartialResultHandler
 
    /// Initializer
    public init(initialResult: Result, nextPartialResult: @escaping NextPartialResultHandler) {
        self.initialResult = initialResult
        self.nextPartialResult = nextPartialResult
    }
    
}

/// Wrapper for the reduce with index
public struct ReducingParametersWithIndex<I, R>: ReducingParameters {
    
    /// Input of the collection
    public typealias Input = I
    /// Result of the reducing function
    public typealias Result = R
    /// Format of the nextPartialResult handler
    public typealias NextPartialResultHandler = (Result, Input, Int) -> (Result)
    
    /// Initial value given to the result
    public let initialResult: Result
    /// Reducing function
    public let nextPartialResult: NextPartialResultHandler
    
    /// Initializer
    public init(initialResult: Result, nextPartialResult: @escaping NextPartialResultHandler) {
        self.initialResult = initialResult
        self.nextPartialResult = nextPartialResult
    }
    
}
