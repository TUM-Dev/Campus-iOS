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

// MARK: Single Manager with Card Key for sorting

struct CardCategory {
    let key: CardKey
    let elements: [DataElement]
}

protocol CardManager {
    var cardKey: CardKey { get }
    func fetchCardsItems() -> Response<CardCategory?>
}

extension CardManager {
    
    var indexInOrder: Int {
        let cards = PersistentCardOrder.value.cards
        return cards.index(of: cardKey) ?? cards.count
    }
    
}

extension CardManager {
    
    func fetchCard(skipCache: Bool = false) -> Response<CardCategory?> {
        guard skipCache, let manager = self as? CachedCardManager else {
            return fetchCardsItems()
        }
        return manager.updateCardItems()
    }
    
}

protocol CachedCardManager: CardManager {
    var defaultMaxCache: CacheTime { get }
    func fetchCardItems(maxCache: CacheTime) -> Response<CardCategory?>
}

extension CachedCardManager {
    
    func fetchCardsItems() -> Response<CardCategory?> {
        return fetchCardItems(maxCache: defaultMaxCache)
    }
    
    func updateCardItems() -> Response<CardCategory?> {
        return fetchCardItems(maxCache: .time(0))
    }
    
}

protocol TypedCardManager: CardManager {
    associatedtype DataType: DataElement
    func fetchCardItems() -> Response<[DataElement]>
}

extension TypedCardManager {
    
    func fetchCardsItems() -> Response<CardCategory?> {
        return fetchCardItems().map { (elements: [DataElement]) in
            guard !elements.isEmpty else {
                return nil
            }
            return .init(key: self.cardKey, elements: elements)
        }
    }
    
}

protocol SimpleTypedCardManager: TypedCardManager, Manager {
    func cardsItems(from elements: [DataType]) -> [DataType]
}

extension SimpleTypedCardManager {
    
    func cardsItems(from elements: [DataType]) -> [DataType] {
        return elements.array(withFirst: 3)
    }
    
    func fetchCardItems() -> Response<[DataElement]> {
        return fetch().map { self.cardsItems(from: $0) }
    }
    
}

protocol TypedCachedCardManager: SimpleTypedCardManager, CachedCardManager, CachedManager { }

extension TypedCachedCardManager {
    
    func fetchCardsItems() -> Promise<CardCategory?, APIError> {
        return fetchCardItems(maxCache: defaultMaxCache)
    }
    
    func fetchCardItems(maxCache: CacheTime) -> Response<CardCategory?> {
        return fetch(maxCache: maxCache).map { (elements: [DataType]) in
            let elements = self.cardsItems(from: elements)
            guard !elements.isEmpty else {
                return nil
            }
            return .init(key: self.cardKey, elements: elements)
        }
    }
    
}
