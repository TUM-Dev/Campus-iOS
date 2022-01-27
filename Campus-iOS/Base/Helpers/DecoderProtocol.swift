//
//  DecoderProtocol.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Foundation
import Alamofire

protocol DecoderProtocol: AnyObject, DataDecoder {
    associatedtype DateDecodingStrategy: DecodingStrategyProtocol
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    var userInfo: [CodingUserInfoKey : Any] { get set }
    var dateDecodingStrategy: DateDecodingStrategy { get set }
    static var contentType: [String] { get }
    static func instantiate() -> Self
}

protocol DecodingStrategyProtocol { }
