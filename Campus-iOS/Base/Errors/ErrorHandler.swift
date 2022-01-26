//
//  ErrorHandler.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import SwiftUI

protocol ErrorHandler {
    func handle<T: View>(
        _ error: Error?,
        in view: T,
        customEnvironmentValues: Model,
        retryHandler: @escaping () -> Void
    ) -> AnyView
}
