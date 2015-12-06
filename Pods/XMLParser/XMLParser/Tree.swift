//
//  Tree.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A  generic data structure for chaining parsed values.
public class Tree<T> {
    
    // MARK: - Properties 
    
    /// The previous tree if any. It should be weak since it's an optional
    /// and besides we don't want to face cycled referencing.
    public weak var previous: Tree<T>?
    
    /// Self node with values *name* and *value*.
    public let node: (name: String, value: T)
    
    /// The next tree if any.
    public var next: [Tree<T>]?
    
    /// Defines the indentation level.
    private let multiplier = 3
    
    /// A tmp counter for steps.
    private lazy var _steps = 0
    
    /// Steps for reaching the very first tree.
    public var steps: Int {
        get {
            if let previous = previous {
                previous._steps = ++_steps
                return previous.steps
            } else {
                let copy = self._steps
                self._steps = 0
                return copy
            }
        }
        
    }
    
    // MARK: - Initialization
    
    /// A general initializer.
    public init(previous: Tree<T>?, node: (String, T), next: [Tree<T>]?) {
        self.previous = previous
        self.node = node
        self.next = next
    }
    
    // MARK: - Convenience stuff
    
    public convenience init(node: (String, T)) {
        self.init(previous: nil, node: node, next: nil)
    }
    
    public convenience init(previous: Tree<T>, node: (String, T)) {
        self.init(previous: previous, node: node, next: nil)
    }
    
    public convenience init(node: (String, T), next: [Tree<T>]) {
        self.init(previous: nil, node: node, next: next)
    }
    
    // MARK: - Utils
    
    /// Returns the very first tree.
    public func first() -> Tree<T> {
        if let previous = previous {
            return previous.first()
        } else {
            return self
        }
    }
}

// MARK: - Parsing utils

extension Tree {
    /// A util function that parsed the current tree structure into 
    /// an XML string.
    public func parsedRequestBody() -> String {
        var body = ""
        
        func spaces(count: Int) -> String {
            var string = ""
            for _ in 0..<count {
                string += " "
            }
            
            return string
        }
        
        func process(tree: Tree<T>) {
            let spaces = spaces(tree.steps * multiplier)
            
            if body.characters.count > 0 && body.characters.last != "\n" {
                body += "\n"
            }
            
            body += spaces
            body += tree.node.name.startHeader()
            
            
            if tree.next == nil || tree.next?.count == 0 {
                body += "\(tree.node.value)"
            }
            
            if let tries = tree.next {
                for tree in tries {
                    process(tree)
                }
            }
            
            if body.characters.last == "\n" {
                body += spaces
            }
            
            body += tree.node.name.endHeader()
            body += "\n"
        }
        
        process(self)
        
        return body
        
    }
}

// MARK: - Equatable

public func ==<T>(lhs: Tree<T>, rhs: Tree<T>) -> Bool {
    return lhs === rhs
}
