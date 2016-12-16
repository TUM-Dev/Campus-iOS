//
//  Promise.swift
//
//  Created by Mathias Quintero on 12/2/16.
//
//

import Foundation

/// Promise Structs to prevent you from nesting callbacks over and over again
public class Promise<T, E: Error> {
    
    /// Type of the success
    typealias SuccessHandler = (T) -> ()
    /// Type of the success
    typealias ErrorHandler = (E) -> ()
    
    /// All the handlers
    var successHandlers = [SuccessHandler]()
    var errorHandlers = [ErrorHandler]()
    
    /// Initializer
    public init() {}
    
    /**
     Add success handler
     
     - Parameter handler: function that should be called
     
     - Returns: argOne
     */
    @discardableResult public func onSuccess<O>(call handler: @escaping (T) -> (O)) -> PromiseSuccessHandler<O, T, E> {
        return PromiseSuccessHandler<O, T, E>(promise: self, handler: handler)
    }
    
    /// Add an error Handler
    @discardableResult public func onError<O>(call handler: @escaping (E) -> (O)) -> PromiseErrorHandler<O, T, E> {
        return PromiseErrorHandler<O, T, E>(promise: self, handler: handler)
    }
    
    /// Call this when the promise is fulfilled
    public func success(with value: T) {
        successHandlers => { value | $0 }
    }
    
    /// Call this when the promise has an error
    public func error(with value: E) {
        errorHandlers => { value | $0 }
    }
    
}
