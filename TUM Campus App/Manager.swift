//
//  Manager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

protocol DetailsForDataManager {
    associatedtype DataType
    associatedtype ResponseType
    init(config: Config)
    func fetch(for data: DataType) -> Response<ResponseType>
}

protocol DetailsManager: DetailsForDataManager {
    func fetch(for data: DataType) -> Response<DataType>
}

protocol SimpleSearchManager {
    init(config: Config)
    func search(query: String) -> Response<[DataElement]>
}

protocol SearchManager: SimpleSearchManager {
    associatedtype DataType: DataElement
    func search(query: String) -> Response<[DataType]>
}

extension SearchManager {
    
    func search(query: String) -> Response<[DataElement]> {
        return search(query: query).map { $0.map { $0 as DataElement } }
    }
    
}

protocol SimpleManager {
    init(config: Config)
    var requiresLogin: Bool { get }
    func fetch() -> Response<[DataElement]>
}

protocol NewManager: SimpleManager {
    associatedtype DataType: DataElement
    func fetch() -> Response<[DataType]>
}

protocol SimpleSingleManager: SimpleManager {
    func fetchSingle() -> Response<DataElement?>
}

extension NewManager {
    
    func fetch() -> Promise<[DataElement], APIError> {
        return fetch().map { $0.map { $0 as DataElement } }
    }
    
}

protocol SingleItemManager: SimpleSingleManager, NewManager {
    func toSingle(from items: [DataType]) -> DataElement?
}

extension SingleItemManager {
    
    func toSingle(from items: [DataType]) -> DataElement? {
        return items.first
    }
    
    func fetchSingle() -> Response<DataElement?> {
        return fetch().map { self.toSingle(from: $0) }
    }
    
}
