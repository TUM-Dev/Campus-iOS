//
//  Set.swift
//  Pods
//
//  Created by Mathias Quintero on 12/16/16.
//
//

import Foundation

extension Set: Defaultable {
    
    /// Default Value
    public static var defaultValue: Set<Element> {
        return [].set
    }
    
}
