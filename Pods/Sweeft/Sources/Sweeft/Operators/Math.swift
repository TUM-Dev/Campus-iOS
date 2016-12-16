//
//  Functional.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator **: PowerPrecedence

/**
 Exponentiates
 
 - Parameter a: Base
 - Parameter b: Exponent
 
 - Returns: a to the b
 */
public func **(_ a: Double, _ b: Double) -> Double {
    return pow(a, b)
}

/**
 Exponentiates
 
 - Parameter a: Base
 - Parameter b: Exponent
 
 - Returns: a to the b
 */
public func **(_ a: Int, _ b: Int) -> Int {
    return Int(Double(a) ** Double(b))
}

/**
 Remainder
 
 - Parameter a: number
 - Parameter b: divider
 
 - Returns: remainder of a after dividing by b
 */
public func %(_ a: Double, _ b: Double) -> Double {
    return a.remainder(dividingBy: b)
}

prefix operator |

/**
 Abs
 
 - Parameter value: Number
 
 - Returns: absolut value of the input
 */
public prefix func |(_ value: Int) -> Int {
    return abs(value)
}


infix operator ~~: ComparisonPrecedence

/**
 Matches
 
 - Parameter eft: String
 - Parameter ight: Pattern
 
 - Returns: does the string match the pattern
 */
public func ~~(left: String, right: String) -> Bool {
    return ??(try? left.matches(pattern: right, options: []))
}

/**
 Get difference between two dates
 
 - Parameter left: firstDate
 - Parameter right: secondDate
 
 - Returns: DateDifference instance
 */
public func -(_ left: Date, _ right: Date) -> DateDifference {
    return DateDifference(first: left, second: right)
}
