//
//  ErrorEmittingViewModifier.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import SwiftUI

struct ErrorEmittingViewModifier: ViewModifier {
    @EnvironmentObject var customEnvironmentValues: Model
    @Environment(\.errorHandler) var handler

    var error: Error?
    var retryHandler: () -> Void

    func body(content: Content) -> some View {
        handler.handle(error,
            in: content,
            customEnvironmentValues: customEnvironmentValues,
            retryHandler: retryHandler
        )
    }
}
