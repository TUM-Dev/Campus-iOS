//
//  ComparisonToken.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

infix operator =/

struct ComparisonToken: Hashable {
    var value: String
    var type: ComparisonTokenType = .tokenized
    
    enum ComparisonTokenType {
        case tokenized
        case raw
    }
    
    static func =/ (lhs: Self, rhs: Self) -> Bool {
        guard lhs.value.count == rhs.value.count else {
            return false
        }
        
        for i in 0..<lhs.value.count {
            if Array(lhs.value)[i] != Array(rhs.value)[i] {
                return false
            }
        }
        
        return true
    }
}
