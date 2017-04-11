//
//  Node.swift
//  Pods
//
//  Created by Mathias Quintero on 2/22/17.
//
//

import Foundation

public enum Connection<Identifier: Hashable> {
    case simple(to: Identifier)
    case cost(to: Identifier, cost: Double)
}

extension Connection {
    
    var identifier: Identifier {
        switch self {
        case .simple(let identifier):
            return identifier
        case  .cost(let identifier, _):
            return identifier
        }
    }
    
    var cost: Double {
        switch self {
        case .cost(_, let cost):
            return cost
        default:
            return 1
        }
    }
    
}

public protocol NodeProvider {
    associatedtype Node
    associatedtype Identifier
    func node(for identifier: Identifier) -> Node?
}

public protocol GraphNode {
    associatedtype Identifier: Hashable
    var identifier: Identifier { get }
    func neighbours() -> ResultPromise<[Connection<Identifier>]>
    func neighbours<P: NodeProvider>(in provider: P) -> ResultPromise<[(Self, Double)]> where P.Node == Self, P.Identifier == Identifier
}

extension GraphNode {
    
    public func neighbours<P: NodeProvider>(in provider: P) -> ResultPromise<[(Self, Double)]> where P.Node == Self, P.Identifier == Self.Identifier {
        
        return self.neighbours().nested {
            return $0.flatMap({ (provider.node(for: $0.identifier), $0.cost) } >>> iff)
        }
    }
    
}


public protocol HashableNode: GraphNode, Hashable {
    func neighbours() -> ResultPromise<[Connection<Self>]>
}

public extension HashableNode {
    
    typealias Identifier = Self
    
    public var identifier: Self {
        return self
    }
    
}

public extension HashableNode {
    
    func neighbours<P: NodeProvider>(in provider: P) -> ResultPromise<[(Self, Double)]>
                                                    where P.Node == Self, P.Identifier == Self.Identifier {
        
        return neighbours().nested {
            $0.map { ($0.identifier, $0.cost) }
        }
    }
    
}

public extension HashableNode {
    
    func bfs(to destination: Self) -> ResultPromise<[Self.Identifier]?> {
        return bfs { $0 == destination.identifier }
    }
    
    func bfs(until isFinal: @escaping (Self.Identifier) -> Bool) -> ResultPromise<[Self.Identifier]?> {
        let graph = Graph<Self>()
        return graph.bfs(from: self, until: isFinal)
    }
    
    func dfs(to destination: Self) -> ResultPromise<[Self.Identifier]?> {
        return dfs { $0 == destination.identifier }
    }
    
    func dfs(until isFinal: @escaping (Self.Identifier) -> Bool) -> ResultPromise<[Self.Identifier]?> {
        let graph = Graph<Self>()
        return graph.dfs(from: self, until: isFinal)
    }
    
    func shortestPath(with euristics: @escaping (Self.Identifier) -> Double = **{ 0 },
                      to destination: Self) -> ResultPromise<[Self.Identifier]?> {
        
        return shortestPath(with: euristics, until: { $0 == destination.identifier })
    }
    
    func shortestPath(with euristics: @escaping (Self.Identifier) -> Double = **{ 0 },
                      until isFinal: @escaping (Self.Identifier) -> Bool) -> ResultPromise<[Self.Identifier]?> {
        
        let graph = Graph<Self>()
        return graph.shortestPath(from: self, with: euristics, until: isFinal)
    }
    
}

public protocol SimpleNode: GraphNode {
    func neighbourIdentifiers() -> ResultPromise<[Identifier]>
}

public extension SimpleNode {
    
    public func neighbours() -> Promise<[Connection<Self.Identifier>], AnyError> {
        
        return neighbourIdentifiers().nested { identifiers in
            identifiers => Connection.simple
        }
    }
}

public protocol SyncNode: GraphNode {
    var neighbours: [Connection<Identifier>] { get }
}

extension SyncNode {
    
    public func neighbours() -> Promise<[Connection<Self.Identifier>], AnyError> {
        return .successful(with: neighbours)
    }
    
}

public protocol SimpleSyncNode: SyncNode {
    var neighbourIdentifiers: [Identifier] { get }
}

extension SimpleSyncNode {
    
    public var neighbours: [Connection<Identifier>] {
        return neighbourIdentifiers => Connection.simple
    }
    
}

public struct GenericNode<T: Hashable>: SyncNode {
    
    public typealias Identifier = T
    
    public var identifier: T {
        return data
    }
    
    public let data: T
    public let neighbours: [Connection<T>]
}
