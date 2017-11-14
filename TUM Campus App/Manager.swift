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
    var categoryKey: SearchResultKey { get }
    func search(query: String) -> Response<[DataElement]>
}

extension SimpleSearchManager {
    
    func search(query: String) -> Response<SearchResults> {
        return search(query: query).map { .init(key: self.categoryKey, results: $0) }
    }
    
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
    var requiresLogin: Bool { get }
    func fetch() -> Response<[DataElement]>
}

protocol Manager: SimpleManager {
    associatedtype DataType: DataElement
    func fetch() -> Response<[DataType]>
}

extension Manager {
    
    func fetch() -> Promise<[DataElement], APIError> {
        return fetch().map { $0.map { $0 as DataElement } }
    }
    
}

protocol CachedManager: Manager {
    var defaultMaxCache: CacheTime { get }
    func fetch(maxCache: CacheTime) -> Response<[DataType]>
}

extension CachedManager {
    
    func update() -> Response<[DataType]> {
        return fetch(maxCache: .time(0))
    }
    
    func fetch() -> Response<[DataType]> {
        return fetch(maxCache: defaultMaxCache)
    }
    
    func fetch(skipCache: Bool) -> Response<[DataType]> {
        return skipCache ? update() : fetch()
    }
    
}

// MARK: Managers that can return a single item
protocol SimpleSingleManager: SimpleManager {
    func fetchSingle() -> Response<DataElement?>
}

protocol SingleItemManager: SimpleSingleManager, Manager {
    func toSingle(from items: [DataType]) -> DataElement?
}

extension SingleItemManager {
    
    func toSingle(from items: [DataType]) -> DataElement? {
        return items.first
    }
    
    func fetchSingle() -> Response<DataElement?> {
        return fetch().map(self.toSingle(from:))
    }
    
}

// MARK: Single Managers that are cached

protocol SimpleSingleCachedManager: SimpleSingleManager {
    var defaultMaxCache: CacheTime { get }
    func fetchSingle(maxCache: CacheTime) -> Response<DataElement?>
}

extension SimpleSingleCachedManager {
    
    func updateSingle() -> Response<DataElement?> {
        return fetchSingle(maxCache: .time(0))
    }
    
    func fetchSingle() -> Response<DataElement?> {
        return fetchSingle(maxCache: defaultMaxCache)
    }
    
}

protocol SingleItemCachedManager: SimpleSingleCachedManager, CachedManager {
    func toSingle(from items: [DataType]) -> DataElement?
}

extension SingleItemCachedManager {
    
    func toSingle(from items: [DataType]) -> DataElement? {
        return items.first
    }
    
    func fetchSingle(maxCache: CacheTime) -> Promise<DataElement?, APIError> {
        return fetch(maxCache: maxCache).map(self.toSingle(from:))
    }
    
}

// MARK: Single Manager with Card Key for sorting

protocol CardManager: SimpleSingleManager {
    var cardKey: CardKey { get }
}

extension CardManager {
    
    var indexInOrder: Int {
        let cards = PersistentCardOrder.value.cards
        return cards.index(of: cardKey) ?? cards.count
    }
    
}

extension CardManager {
    
    func fetchCard(skipCache: Bool = false) -> Response<DataElement?> {
        guard skipCache, let manager = self as? SimpleSingleCachedManager else {
            return fetchSingle()
        }
        return manager.updateSingle()
    }
    
}
