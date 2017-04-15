//
//  Graph.swift
//  Pods
//
//  Created by Mathias Quintero on 2/22/17.
//


import Foundation

public class Graph<Node: GraphNode>: NodeProvider {
    
    public typealias Identifier = Node.Identifier
    
    let nodes: [Identifier : Node]
    
    init(from nodes: [Node] = .empty) {
        self.nodes = nodes >>= { ($0.identifier, $0) }
    }
    
    public func node(for identifier: Identifier) -> Node? {
        return self.nodes[identifier]
    }
    
}

struct QueueEntry<T: GraphNode>: Hashable {
    
    public var hashValue: Int {
        return item.identifier.hashValue
    }

    let item: T
    
    public static func ==(lhs: QueueEntry<T>, rhs: QueueEntry<T>) -> Bool {
        return lhs.item.identifier == rhs.item.identifier
    }
    
}

extension Graph {
    
    fileprivate func computePath<V>(using prevs: [V:V], until last: V) -> [V] {
        if let prev = prevs[last] {
            return [last] + computePath(using: prevs, until: prev)
        } else {
            return [last]
        }
    }
    
    private func iterate(queue: PriorityQueue<QueueEntry<Node>, Double>,
                 prevs: [Identifier : Identifier],
                 costs: [Identifier : Double],
                 source: Identifier,
                 euristic: @escaping (Identifier) -> Double,
                 isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<[Identifier]?> {
        
        var costs = costs
        var prevs = prevs
        
        return .new { promise in
            if let current = queue.pop()?.item {
                if isFinal(current.identifier) {
                    promise.success(with: <>computePath(using: prevs, until: current.identifier))
                } else {
                    let cost = costs[current.identifier].?
                    current.neighbours(in: self).onSuccess { neighbours in
                        neighbours => { item in
                            let entry = QueueEntry(item: item.0)
                            let estimate = cost + item.1 + euristic(item.0.identifier)
                            if let priority = queue.priority(for: entry) {
                                if estimate < priority {
                                    queue.update(entry, with: estimate)
                                    prevs[item.0.identifier] = current.identifier
                                    costs[item.0.identifier] = cost + item.1
                                }
                            } else if prevs[item.0.identifier] == nil, source != item.0.identifier {
                                queue.add(entry, with: estimate)
                                prevs[item.0.identifier] = current.identifier
                                costs[item.0.identifier] = cost + item.1
                            }
                        }
                        self.iterate(queue: queue, prevs: prevs, costs: costs,
                                     source: source, euristic: euristic, isFinal: isFinal).nest(to: promise, using: id)
                        }
                        .onError { _ in
                            self.iterate(queue: queue, prevs: prevs, costs: costs,
                                         source: source, euristic: euristic, isFinal: isFinal).nest(to: promise, using: id)
                    }
                }
            } else {
                promise.success(with: nil)
            }
        }
    }
    
    public func shortestPath(from source: Node,
                             with euristic: @escaping (Identifier) -> Double = **{ 0 },
                             until isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<[Identifier]?> {
        
        let queue = PriorityQueue<QueueEntry<Node>, Double>()
        queue.add(QueueEntry(item: source), with: 0)
        
        return iterate(queue: queue, prevs: .empty, costs: .empty,
                       source: source.identifier, euristic: euristic, isFinal: isFinal)
    }
    
}

extension Graph {
    
    private func iterate(queue: [Node],
                         parents: [Identifier:Identifier],
                         source: Identifier,
                         isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<[Identifier]?> {
        
        var parents = parents
        var queue = queue
        
        return .new { promise in
            if !queue.isEmpty {
                let current = queue.remove(at: 0)
                current.neighbours(in: self).onSuccess { neighbours in
                    if let item = neighbours.filter({ $0.0.identifier } >>> isFinal).first {
                        parents[item.0.identifier] = current.identifier
                        promise.success(with: <>self.computePath(using: parents, until: item.0.identifier))
                    } else {
                        neighbours => { item in
                            if parents[item.0.identifier] == nil, source != item.0.identifier {
                                parents[item.0.identifier] = current.identifier
                                queue.append(item.0)
                            }
                        }
                        self.iterate(queue: queue, parents: parents,
                                     source: source, isFinal: isFinal).nest(to: promise, using: id)
                    }
                    }
                    .onError { _ in
                        self.iterate(queue: queue, parents: parents,
                                     source: source, isFinal: isFinal).nest(to: promise, using: id)
                }
            } else {
                promise.success(with: nil)
            }
        }
    }
    
    public func bfs(from source: Node,
                    until isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<[Identifier]?> {
        
        if isFinal(source.identifier) {
            return .successful(with: [source.identifier])
        }
        let queue = [source]
        return iterate(queue: queue, parents: .empty, source: source.identifier, isFinal: isFinal)
    }
    
}

extension Graph {
    
    private func iterate(nodes: [Node],
                 parents: [Identifier:Identifier],
                 source: Identifier,
                 until isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<([Identifier:Identifier],Identifier?)> {
        
        
        var parents = parents
        var nodes = nodes
        
        return .new { promise in
            if !nodes.isEmpty {
                let current = nodes.remove(at: 0)
                current.neighbours(in: self).onSuccess { neighbours in
                    if let item = neighbours.filter({ $0.0.identifier } >>> isFinal).first {
                        parents[item.0.identifier] = current.identifier
                        promise.success(with: (parents, item.0.identifier))
                    } else {
                        let neighbours = neighbours => { $0.0 } |> { parents[$0.identifier] == nil && source != $0.identifier }
                        neighbours => {
                            parents[$0.identifier] = current.identifier
                        }
                        self.iterate(nodes: neighbours, parents: parents, source: source, until: isFinal).onSuccess { result in
                            parents = result.0
                            if let result = result.1 {
                                promise.success(with: (parents, result))
                            } else {
                                self.iterate(nodes: nodes, parents: parents, source: source, until: isFinal).nest(to: promise, using: id)
                            }
                        }
                    }
                    }
                    .onError { _ in
                        self.iterate(nodes: nodes, parents: parents, source: source, until: isFinal)
                }
            } else {
                promise.success(with: (parents, nil))
            }
        }
    }
    
    public func dfs(from source: Node,
                    until isFinal: @escaping (Identifier) -> Bool) -> ResultPromise<[Identifier]?> {
        
        if isFinal(source.identifier) {
            return .successful(with: [source.identifier])
        }
        let promise = iterate(nodes: [source], parents: .empty, source: source.identifier, until: isFinal)
        return promise.nested { (prevs, item) -> [Identifier]? in
            guard let item = item else {
                return nil
            }
            return <>self.computePath(using: prevs, until: item)
        }
    }
    
}
