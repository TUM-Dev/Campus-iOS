//
//  Extensions.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import Foundation
import Ono
import SWXMLHash
import Alamofire

extension Bundle {
    
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1"
    }
    
    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
    
    var userAgent: String {
        return "TCA iOS \(version)/\(build)"
    }
    
}

enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

extension DataRequest {
    static func xmlResponseSerializer() -> DataResponseSerializer<XMLIndexer> {
        return DataResponseSerializer { (_, response, data, error) -> Result<XMLIndexer> in
            
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            
            guard case let .success(validData) = result else {
                return .failure(BackendError.dataSerialization(error: result.error! as! AFError))
            }
            
            let xmlParser = SWXMLHash.config { config in config.detectParsingErrors = true }
            let xml = xmlParser.parse(validData)
            
            switch xml {
            case let .xmlError(error):
                return .failure(BackendError.xmlSerialization(error: error))
            default:
                return .success(xml)
            }
        }
    }
    
    @discardableResult
    func responseXML(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<XMLIndexer>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.xmlResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}
