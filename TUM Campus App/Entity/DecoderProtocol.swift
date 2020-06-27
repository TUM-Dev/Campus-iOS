//
//  DecoderProtocol.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/27/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import XMLCoder
import Alamofire

protocol DecoderProtocol: class, DataDecoder {
    associatedtype DateDecodingStrategy: DecodingStrategyProtocol
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    var userInfo: [CodingUserInfoKey : Any] { get set }
    var dateDecodingStrategy: DateDecodingStrategy { get set }
    static var contentType: [String] { get }
    static func instantiate() -> Self
}

protocol DecodingStrategyProtocol { }

extension JSONDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension XMLDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension JSONDecoder: DecoderProtocol {
    static var contentType: [String] { return ["application/json"] }
    static func instantiate() -> Self {
        //  infers the type of self from the calling context:
        func helper<T>() -> T {
            let decoder = JSONDecoder()
            return decoder as! T
        }
        return helper()
    }
}

extension XMLDecoder: DecoderProtocol {
    static var contentType: [String] { return ["text/xml"] }
    static func instantiate() -> Self {
        // infers the type of self from the calling context
        func helper<T>() -> T {
            let decoder = XMLDecoder()
            return decoder as! T
        }
        return helper()
    }
}
