//
//  DefaultStatusKey.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

/// Key usable to store a status
public protocol StatusKey {
    /// Raw value string for the key
    var rawValue: String { get }
}

extension StatusKey {
    
    var userDefaultsKey: String {
        return String(describing: Self.self) + "." + rawValue
    }
    
}
