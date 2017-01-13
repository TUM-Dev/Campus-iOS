//
//  ValueComparable.swift
//  Pods
//
//  Created by Mathias Quintero on 1/4/17.
//
//

import Foundation

public protocol ValueComparable: Comparable {
    associatedtype ComparableValue: Comparable
    var comparable: ComparableValue { get }
}

public func ==<C: ValueComparable>(_ lhs: C, _ rhs: C) -> Bool {
    return lhs.comparable == rhs.comparable
}

public func <<C: ValueComparable>(_ lhs: C, _ rhs: C) -> Bool {
    return lhs.comparable < rhs.comparable
}

public func <=<C: ValueComparable>(_ lhs: C, _ rhs: C) -> Bool {
    return lhs.comparable <= rhs.comparable
}

public func ><C: ValueComparable>(_ lhs: C, _ rhs: C) -> Bool {
    return lhs.comparable > rhs.comparable
}

public func >=<C: ValueComparable>(_ lhs: C, _ rhs: C) -> Bool {
    return lhs.comparable >= rhs.comparable
}
