//
//  DefaultStatusSerializable.swift
//  Pods
//
//  Created by Mathias Quintero on 12/11/16.
//
//

import Foundation

/// Item that is serializable for UserDefaults
public protocol StatusSerializable {
    /// Serialized into dictionary
    var serialized: [String:Any] { get }
    /// get from serialized dictionary
    init?(from status: [String:Any])
}
