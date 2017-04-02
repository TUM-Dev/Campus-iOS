//
//  BulkPromise.swift
//  Pods
//
//  Created by Mathias Quintero on 12/29/16.
//
//

import Foundation

/// A promise that represent a collection of other promises and waits for them all to be finished
public class BulkPromise<T, O: Error>: Promise<[T], O> {
    
    private let count: Int
    private var results: [(Int, T)] = .empty {
        didSet {
            if results.count == count {
                success(with: results.sorted(ascending: firstArgument) => lastArgument)
            }
        }
    }
    
    init(promises: [Promise<T,O>], completionQueue: DispatchQueue = .main) {
        count = promises.count
        super.init(completionQueue: completionQueue)
        promises => { promise, index in
            promise.nest(to: self) { result in
                self.results.append((index, result))
            }
        }
    }
    
}

extension BulkPromise where T: Collection {
    
    var flattened: Promise<[T.Iterator.Element], O> {
        return nested { result in
            return result.flatMap(id)
        }
    }
    
}
