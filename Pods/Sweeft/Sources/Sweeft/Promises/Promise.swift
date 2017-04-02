//
//  Promise.swift
//
//  Created by Mathias Quintero on 12/2/16.
//
//

import Foundation

enum PromiseState<T, E: Error> {
    case waiting
    case success(result: T)
    case error(error: E)
    
    var result: T? {
        switch self {
        case .success(let result):
            return result
        default:
            return nil
        }
    }
    
    var error: E? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
}

public protocol PromiseBody {
    associatedtype Result
    associatedtype ErrorType: Error
    func onSuccess<O>(call handler: @escaping (Result) -> (O)) -> PromiseSuccessHandler<O, Result, ErrorType>
    func onError<O>(call handler: @escaping (ErrorType) -> (O)) -> PromiseErrorHandler<O, Result, ErrorType>
    func nest<V>(to promise: Promise<V, ErrorType>, using mapper: @escaping (Result) -> (V))
    func nest<V>(to promise: Promise<V, ErrorType>, using mapper: @escaping (Result) -> ())
}

/// Promise Structs to prevent you from nesting callbacks over and over again
public class Promise<T, E: Error>: PromiseBody {
    
    /// Type of the success
    typealias SuccessHandler = (T) -> ()
    /// Type of the success
    typealias ErrorHandler = (E) -> ()
    
    /// All the handlers
    var successHandlers = [SuccessHandler]()
    var errorHandlers = [ErrorHandler]()
    var state: PromiseState<T, E> = .waiting
    let completionQueue: DispatchQueue
    
    /// Initializer
    public init(completionQueue: DispatchQueue = .main) {
        self.completionQueue = completionQueue
    }
    
    /**
     Add success handler
     
     - Parameter handler: function that should be called
     
     - Returns: PromiseHandler Object
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
        state = .success(result: value)
        completionQueue >>> {
            self.successHandlers => apply(value: value)
        }
    }
    
    /// Call this when the promise has an error
    public func error(with value: E) {
        state = .error(error: value)
        completionQueue >>> {
            self.errorHandlers => apply(value: value)
        }
    }
    
    /// Will nest a promise inside another one
    public func nest<V>(to promise: Promise<V, E>, using mapper: @escaping (T) -> (V)) {
        onSuccess(call: mapper >>> promise.success)
        onError(call: promise.error)
    }
    
    /// Will nest a promise inside another one
    public func nest<V>(to promise: Promise<V, E>, using mapper: @escaping (T) -> ()) {
        onSuccess(call: mapper)
        onError(call: promise.error)
    }
    
    /// Will create a Promise that is based on this promise but maps the result
    public func nested<V>(_ mapper: @escaping (T) -> V) -> Promise<V, E> {
        let promise = Promise<V, E>(completionQueue: completionQueue)
        nest(to: promise, using: mapper)
        return promise
    }
    
    /// Will create a Promise that is based on this promise but maps the result
    public func nested<V>(_ mapper: @escaping (T, Promise<V, E>) -> ()) -> Promise<V, E> {
        let promise = Promise<V, E>(completionQueue: completionQueue)
        nest(to: promise, using: add(trailing: promise) >>> mapper)
        return promise
    }
    
}
