//
//  Promise.swift
//
//  Created by Mathias Quintero on 12/2/16.
//
//

import Foundation

public typealias ResultPromise<R> = Promise<R, AnyError>

enum PromiseState<T, E: Error> {
    case waiting
    case success(result: T)
    case error(error: E)
    
    var isDone: Bool {
        switch self {
        case .waiting:
            return false
        default:
            return true
        }
    }
    
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
    
    public init(successful value: T, completionQueue: DispatchQueue = .main) {
        self.completionQueue = completionQueue
        self.state = .success(result: value)
    }
    
    public init(errored value: E, completionQueue: DispatchQueue = .main) {
        self.completionQueue = completionQueue
        self.state = .error(error: value)
    }
    
    public static func successful(with value: T) -> Promise<T, E> {
        return Promise<T, E>(successful: value)
    }
    
    public static func errored(with value: E) -> Promise<T, E> {
        return Promise<T, E>(errored: value)
    }
    
    public static func new(completionQueue: DispatchQueue = .main, _ handle: (Promise<T, E>) -> ()) -> Promise<T, E> {
        let promise = Promise<T, E>(completionQueue: completionQueue)
        handle(promise)
        return promise
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
        guard !state.isDone else {
            return
        }
        state = .success(result: value)
        let count = self.successHandlers.count
        completionQueue >>> {
            self.successHandlers.array(withFirst: count) => apply(value: value)
        }
    }
    
    /// Call this when the promise has an error
    public func error(with value: E) {
        guard !state.isDone else {
            return
        }
        state = .error(error: value)
        let count = self.errorHandlers.count
        completionQueue >>> {
            self.errorHandlers.array(withFirst: count) => apply(value: value)
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
        return .new { promise in
            self.nest(to: promise, using: mapper)
        }
    }
    
    /// Will create a Promise that is based on this promise but maps the result
    public func nested<V>(_ mapper: @escaping (T, Promise<V, E>) -> ()) -> Promise<V, E> {
        return .new { promise in
            self.nest(to: promise, using: add(trailing: promise) >>> mapper)
        }
    }
    
    public func generalizeError() -> Promise<T, AnyError> {
        return .new { promise in
            onSuccess(call: promise.success)
            onError(call: AnyError.error >>> promise.error)
        }
    }
    
    /**
     Turns an asynchrounous handler into a synchrounous one. 
     Warning! This can result really badly. Be very careful when calling this.
     
     
     - Returns: Result of your promise
     */
    public func wait() throws -> T {
        let group = DispatchGroup()
        group.enter()
        onSuccess { _ in
            group.leave()
        }
        onError { _ in
            group.leave()
        }
        group.wait()
        if let result = state.result {
            return result
        }
        throw state.error!
    }
    
}
