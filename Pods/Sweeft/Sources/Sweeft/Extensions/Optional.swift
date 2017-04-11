//
//  Optional.swift
//  Pods
//
//  Created by Mathias Quintero on 2/27/17.
//
//

import Foundation

extension Optional where Wrapped: Serializable {
    
    var json: JSON {
        switch self {
        case .some(let item):
            return item.json
        default:
            return .null
        }
    }
    
}
