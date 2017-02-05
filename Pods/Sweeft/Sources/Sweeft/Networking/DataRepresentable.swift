//
//  DataRepresentable.swift
//  Pods
//
//  Created by Mathias Quintero on 12/29/16.
//
//

import Foundation

/// Any object that can be fetched throught http as Data
public protocol DataRepresentable {
    static var accept: String? { get }
    init?(data: Data)
}

public extension DataRepresentable {
    
    /// Result of a Single Object
    public typealias Result = Response<Self>
    /// Result of an Array of Objects
    public typealias Results = Response<[Self]>
    
}

public extension DataRepresentable {
    
    static var accept: String? {
        return nil
    }
    
}

/// Any object that can be sent through http as Data
public protocol DataSerializable {
    var contentType: String? { get }
    var data: Data? { get }
}

public extension DataSerializable {
    
    var contentType: String? {
        return nil
    }
    
}

public extension DataSerializable {
    
    public func send<T: API, R: DataRepresentable>(using api: T,
                     method: HTTPMethod,
                     at endpoint: T.Endpoint,
                     arguments: [String:CustomStringConvertible] = .empty,
                     headers: [String:CustomStringConvertible] = .empty,
                     queries: [String:CustomStringConvertible] = .empty,
                     auth: Auth = NoAuth.standard) -> Response<R> {
        
        return api.doRepresentedRequest(with: method, to: endpoint, arguments: arguments, headers: headers, queries: queries, auth: auth, body: self)
    }
    
    public func put<T: API, R: DataRepresentable>(using api: T,
                    at endpoint: T.Endpoint,
                    arguments: [String:CustomStringConvertible] = .empty,
                    headers: [String:CustomStringConvertible] = .empty,
                    queries: [String:CustomStringConvertible] = .empty,
                    auth: Auth = NoAuth.standard) -> Response<R> {
        
        return send(using: api, method: .put, at: endpoint, arguments: arguments, headers: headers, queries: queries, auth: auth)
    }
    
    public func post<T: API, R: DataRepresentable>(using api: T,
                     at endpoint: T.Endpoint,
                     arguments: [String:CustomStringConvertible] = .empty,
                     headers: [String:CustomStringConvertible] = .empty,
                     queries: [String:CustomStringConvertible] = .empty,
                     auth: Auth = NoAuth.standard) -> Response<R> {
        
        return send(using: api, method: .post, at: endpoint, arguments: arguments, headers: headers, queries: queries, auth: auth)
    }
    
}
