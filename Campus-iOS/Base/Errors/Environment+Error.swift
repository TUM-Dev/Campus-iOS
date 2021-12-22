//
//  Environment+Error.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import SwiftUI

struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    static var defaultValue: ErrorHandler = AlertErrorHandler()
}

extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}
