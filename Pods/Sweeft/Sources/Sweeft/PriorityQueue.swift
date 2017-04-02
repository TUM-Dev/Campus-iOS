//
//  PriorityQueue.swift
//  Pods
//
//  Created by Mathias Quintero on 2/22/17.
//
//

import Foundation

public class PriorityQueue<T: Hashable, P: Comparable> {
    
    var itemPositions: [T:Int] = .empty
    var items: [(item: T, priority: P)] = .empty
    
    public var count: Int {
        return items.count
    }
    
    public var isEmpty: Bool {
        return count < 1
    }
    
    private func swap(_ a: Int, _ b: Int) {
        items[a] <=> items[b]
        itemPositions[items[a].item] = a
        itemPositions[items[b].item] = b
    }
    
    private func childrenOfItem(at index: Int) -> [(element: (item: T, priority: P), index: Int)] {
        let indexes = [2 * index + 1, 2 * index + 2]
        return self.items.withIndex | indexes
    }
    
    private func siftUp(at index: Int) {
        guard index > 0 else {
            return
        }
        let parentIndex = (index - 1)/2
        let parent = items[parentIndex]
        let current = items[index]
        if parent.priority > current.priority {
            self.swap(parentIndex, index)
            siftUp(at: parentIndex)
        }
    }
    
    private func siftDown(at index: Int) {
        let children = childrenOfItem(at: index)
        guard let child = children.argmin({ $0.element.priority }) else {
            return
        }
        if child.element.priority < items[index].priority {
            self.swap(child.index, index)
            siftDown(at: child.index)
        }
    }
    
    public func priority(for item: T) -> P? {
        guard let position = itemPositions[item] else {
            return nil
        }
        return items[position].priority
    }
    
    public func update(_ item: T, with priority: P) {
        guard let position = itemPositions[item] else {
            return
        }
        items[position].priority = priority
        siftUp(at: position)
        if let position = itemPositions[item] {
            siftUp(at: position)
        }
    }
    
    public func add(_ item: T, with priority: P) {
        items.append((item, priority))
        itemPositions[item] = items.lastIndex
        siftUp(at: items.lastIndex)
    }
    
    public func popWithPriority() -> (T, P)? {
        if count > 1 {
            swap(0, items.lastIndex)
            let item = items.removeLast()
            itemPositions[item.item] = nil
            siftDown(at: 0)
            return item
        } else {
            itemPositions = .empty
            let item = items.first
            items = .empty
            return item
        }
    }
    
    public func pop() -> T? {
        return popWithPriority()?.0
    }
    
}
