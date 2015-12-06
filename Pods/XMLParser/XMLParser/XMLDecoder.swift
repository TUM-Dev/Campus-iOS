//
//  XMLDecoder.swift
//  XMLParser
//
//  Created by Eugene Mozharovsky on 8/29/15.
//  Copyright © 2015 DotMyWay LCC. All rights reserved.
//

import Foundation

/// A protocol for decoding an input value into an output array.
public protocol XMLDecoder {
    typealias Input
    typealias Output
    
    /// Decodes the given input into the specified output.
    /// - parameter data: An input data, it is defined as a generic 
    /// type but in fact you must provide a **String** input. 
    /// - returns: A defined output, should be an array of values.
    func decode(data: Input) -> Output
}