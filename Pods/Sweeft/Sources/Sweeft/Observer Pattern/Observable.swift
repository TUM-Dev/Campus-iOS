//
//  Observable.swift
//  Pods
//
//  Created by Mathias Quintero on 12/26/16.
//
//

import Foundation

public protocol ObservableContainer {
    associatedtype ObservableItem: Observable
    var observable: ObservableItem { get }
}

public protocol Observable {
    var listeners: [Listener] { get set }
}

public extension Observable {
    
    typealias ListeningHandler = (Self) -> ()
    typealias Listener = (handler: ListeningHandler, queue: DispatchQueue)
    
    public mutating func onChange(in completionQueue: DispatchQueue = .main, do handler: @escaping (Self) -> ()) {
        // Add listener somehow
        listeners.append((handler, completionQueue))
    }
    
    public func hasChanged() {
        listeners => { $0.queue >>> $0.handler ** self }
    }
    
}
