//
//  Errors.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 15.12.21.
//

enum BackendError: Error {
    case network(error: Error)
    case AFError(message: String)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
