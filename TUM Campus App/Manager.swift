//
//  Manager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft


protocol Manager {
    init(mainManager: TumDataManager)
    var requiresLogin: Bool { get }
    func fetchData(_ handler: @escaping ([DataElement]) -> ())
}

extension Manager {
    
    var requiresLogin: Bool {
        return true
    }
    
}

// NEW Stuff!!!

protocol SimpleManager {
    init(config: Config)
    var requiresLogin: Bool { get }
    func fetch() -> Response<[DataElement]>
}

protocol NewManager: SimpleManager {
    associatedtype DataType: DataElement
    func fetch() -> Response<[DataType]>
}

extension NewManager {
    
    func fetch() -> Promise<[DataElement], APIError> {
        return fetch().nested { $0.map { $0 as DataElement } }
    }
    
}

protocol SingleItemManager: NewManager {
    func toSingle(from items: [DataType]) -> DataElement?
}

extension SingleItemManager {
    
    func toSingle(from items: [DataType]) -> DataElement? {
        return items.first
    }
    
    func fetchSingle() -> Response<DataElement?> {
        return fetch().nested { self.toSingle(from: $0) }
    }
    
}

protocol CachedManager: class, NewManager {
    var cache: [DataType] { get set }
    var isLoaded: Bool { get set }
    func perform() -> Response<[DataType]>
}

extension CachedManager {
    
    func fetch() -> Response<[DataType]> {
        guard !isLoaded else {
            return .successful(with: cache)
        }
        return perform().nested { (results: [DataType]) in
            self.isLoaded = true
            self.cache = results
            return results
        }
    }
    
}
