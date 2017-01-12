//
//  Binding.swift
//  Pods
//
//  Created by Mathias Quintero on 12/26/16.
//
//

import Foundation

/// Binding between an observable and a mapping for it's characteristics
public struct Binding<T: Observable, O> {
    
    var value: T
    let mapping: (T) -> O
    
    /// Subscribe to the observable using the mapper
    public mutating func apply(to handler: @escaping (O) -> ()) {
        let mapping = self.mapping
        value | mapping | handler
        value.onChange(do: mapping >>> handler)
    }
    
}

extension Binding {
    
    /// Create Binding from a container
    init<C: ObservableContainer>(container: C, mapping: @escaping (T) -> (O)) where C.ObservableItem == T {
        self.init(value: container.observable, mapping: mapping)
    }
    
}

/// Create a binding
public func **<T: Observable, O>(_ value: T?, _ mapping: @escaping (T) -> (O)) -> Binding<T, O>? {
    guard let value = value else {
        return nil
    }
    return Binding(value: value, mapping: mapping)
}

/// Create a binding
public func **<C: ObservableContainer, O>(_ container: C?, _ mapping: @escaping (C.ObservableItem) -> (O)) -> Binding<C.ObservableItem, O>? {
    guard let container = container else {
        return nil
    }
    return Binding(container: container, mapping: mapping)
}

/// Apply handler to binding
public func >>><T: Observable, O>(_ binding: Binding<T, O>?, _ handler: @escaping (O) -> ()) {
    var binding = binding
    binding?.apply(to: handler)
}

/// Apply handler to observable
public func >>><T: Observable>(_ value: T?, _ handler: @escaping (T) -> ()) {
    value ** id >>> handler
}

/// Apply handler to observable cointainer
public func >>><C: ObservableContainer>(_ value: C?, _ handler: @escaping (C.ObservableItem) -> ()) {
    value ** id >>> handler
}

/// Apply handler to collection of observables
public func >>><C: Collection>(_ items: C, _ handler: @escaping (C.Iterator.Element) -> ()) where C.Iterator.Element: Observable {
    items => { $0 >>> handler }
}

/// Apply handler to collection of observable containers
public func >>><C: Collection>(_ items: C, _ handler: @escaping (C.Iterator.Element.ObservableItem) -> ()) where C.Iterator.Element: ObservableContainer {
    items => { $0 >>> handler }
}

/// Apply handlers to observables by indexing
public func >>><T: Observable>(_ items: [T], _ handlers: [(T) -> ()]) {
    guard items.count == handlers.count else {
        return
    }
    handlers => {
        (items | $1) >>> $0
    }
}
