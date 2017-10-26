//
//  XMLDeserializable.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import SWXMLHash
import Sweeft

extension XMLIndexer: DataRepresentable {
    
    public init?(data: Data) {
        self = SWXMLHash.parse(data)
    }
    
}

protocol XMLDeserializable: DataRepresentable {
    init?(from xml: XMLIndexer)
}

extension XMLDeserializable {
    
    init?(data: Data) {
        let xml = SWXMLHash.parse(data)
        guard let value = Self(from: xml) else {
            return nil
        }
        self = value
    }
    
}

extension XMLIndexer {
    
    func get(at path: [String]) -> XMLIndexer? {
        guard let key = path.first else {
            return self
        }
        var path = path
        path.remove(at: 0)
        let xml = try? self.byKey(key)
        return xml?.get(at: path)
    }
    
}

extension XMLIndexer: XMLDeserializable {
    
    init?(from xml: XMLIndexer) {
        self = xml
    }
    
}

extension API {
    
    func doXMLObjectRequest<T: XMLDeserializable>(with method: HTTPMethod = .get,
                                                  to endpoint: Endpoint,
                                                  arguments: [String:CustomStringConvertible] = .empty,
                                                  headers: [String:CustomStringConvertible] = .empty,
                                                  queries: [String:CustomStringConvertible] = .empty,
                                                  auth: Auth = NoAuth.standard,
                                                  body: Data? = nil,
                                                  acceptableStatusCodes: [Int] = [200],
                                                  completionQueue: DispatchQueue = .global(),
                                                  maxCacheTime: CacheTime = .no) -> Response<T> {
        
        return doRepresentedRequest(with: method,
                                    to: endpoint,
                                    arguments: arguments,
                                    headers: headers,
                                    queries: queries,
                                    auth: auth,
                                    body: body,
                                    acceptableStatusCodes: acceptableStatusCodes,
                                    completionQueue: completionQueue,
                                    maxCacheTime: maxCacheTime)
    }
    
    func doXMLObjectsRequest<T: XMLDeserializable>(with method: HTTPMethod = .get,
                                                   to endpoint: Endpoint,
                                                   arguments: [String:CustomStringConvertible] = .empty,
                                                   headers: [String:CustomStringConvertible] = .empty,
                                                   queries: [String:CustomStringConvertible] = .empty,
                                                   auth: Auth = NoAuth.standard,
                                                   body: Data? = nil,
                                                   acceptableStatusCodes: [Int] = [200],
                                                   completionQueue: DispatchQueue = .global(),
                                                   at path: String...,
                                                   maxCacheTime: CacheTime = .no) -> Response<[T]> {
        
        return doRepresentedRequest(with: method,
                                    to: endpoint,
                                    arguments: arguments,
                                    headers: headers,
                                    queries: queries,
                                    auth: auth,
                                    body: body,
                                    acceptableStatusCodes: acceptableStatusCodes,
                                    maxCacheTime: maxCacheTime).flatMap(completionQueue: completionQueue) { (xml: XMLIndexer) in
        
            let array = xml.get(at: path)?.all ?? []
            return .successful(with: array ==> T.init)
        }
    }
    
}
