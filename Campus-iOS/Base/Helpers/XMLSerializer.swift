//
//  XMLSerializer.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 15.12.21.
//

import Foundation
import Alamofire
import SWXMLHash

final class XMLSerializer: ResponseSerializer {
    let dataPreprocessor: DataPreprocessor
    let emptyResponseCodes: Set<Int>
    let emptyRequestMethods: Set<HTTPMethod>
    let config: (XMLHashOptions) -> Void

    public init(dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<Data?>.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = DecodableResponseSerializer<Data?>.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<Data?>.defaultEmptyRequestMethods,
                config: @escaping (XMLHashOptions) -> Void = { config in config.detectParsingErrors = true }) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.config = config
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> XMLIndexer {
        let result = try DataResponseSerializer().serialize(request: request, response: response, data: data, error: error)
        let xmlParser = XMLHash.config(config)
        let xml = xmlParser.parse(result)

        switch xml {
        case let .xmlError(error):
            throw BackendError.xmlSerialization(error: error)
        default:
            return xml
        }
    }
}
