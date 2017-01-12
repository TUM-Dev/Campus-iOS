//
//  Data.swift
//  Pods
//
//  Created by Mathias Quintero on 12/12/16.
//
//

import Foundation

public extension Data {

    /// Will get any structure representable as data using type inference
    private func get<T: DataRepresentable>() -> T? {
        return T(data: self)
    }
    
    /// String using the utf8 encoding format
    var string: String? {
        return get()
    }
    
    /// JSON object contained in the data
    var json: JSON? {
        return get()
    }
    
}

extension Data: Defaultable {
    
    /// Default value is an empty set of data
    public static var defaultValue: Data {
        return Data()
    }
    
}

extension Data: DataRepresentable {
    
    public init?(data: Data) {
        self = data
    }
    
}

extension Data: DataSerializable {
    
    public var data: Data? {
        return self
    }
    
}
