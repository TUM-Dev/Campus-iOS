//
//  Cache.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 28.12.21.
//

import Foundation
import LRUCache

final class Cache<Key: Hashable, Value> {
    final class Entry {
        let value: Value?
        let expirationDate: Date

        init(value: Value?, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    private let wrapped: LRUCache<Key, Entry>
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    
    init(totalCostLimit: Int = 500_000,
         countLimit: Int = 1_000,
         dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 10 * 60) {
        self.wrapped = LRUCache<Key, Entry>(totalCostLimit: totalCostLimit, countLimit: countLimit)
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
    }
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            self.setValue(newValue, forKey: key)
        }
    }
    
    func setValue(_ value: Value?, forKey key: Key, cost: Int = 5_000) {
        wrapped.setValue(
            Entry(value: value, expirationDate: dateProvider().addingTimeInterval(entryLifetime)),
            forKey: key,
            cost: cost
        )
    }

    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.value(forKey: key) else {
            return nil
        }

        guard dateProvider() < entry.expirationDate else {
            // Discard values that have expired
            removeValue(forKey: key)
            return nil
        }

        return entry.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeValue(forKey: key)
    }
}
