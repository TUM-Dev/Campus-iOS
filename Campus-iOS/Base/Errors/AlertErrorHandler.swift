//
//  AlertErrorHandler.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation
import SwiftUI

struct AlertErrorHandler: ErrorHandler {
    // We give our handler an ID, so that SwiftUI will be able
    // to keep track of the alerts that it creates as it updates
    // our various views:
    private let id = UUID()

    func handle<T: View>(
        _ error: Error?,
        in view: T,
        customEnvironmentValues: Model,
        retryHandler: @escaping () -> Void
    ) -> AnyView {
        /*
        guard error?.resolveCategory() != .requiresLogout else {
            loginStateController.state = .loggedOut
            return AnyView(view)
        }
         */

        var presentation = error.map { Presentation(
            id: id,
            error: $0,
            retryHandler: retryHandler
        )}

        // We need to convert our model to a Binding value in
        // order to be able to present an alert using it:
        let binding = Binding(
            get: { presentation },
            set: { presentation = $0 }
        )

        return AnyView(view.alert(item: binding, content: makeAlert))
    }
}

private extension AlertErrorHandler {
    struct Presentation: Identifiable {
        let id: UUID
        let error: Error
        let retryHandler: () -> Void
    }
    
    func makeAlert(for presentation: Presentation) -> Alert {
        let error = presentation.error

        switch error.resolveCategory() {
        case .retryable:
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                primaryButton: .default(Text("Dismiss")),
                secondaryButton: .default(Text("Retry"),
                    action: presentation.retryHandler
                )
            )
        case .nonRetryable:
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Dismiss"))
            )
        case .requiresLogout:
            // We don't expect this code path to be hit, since
            // we're guarding for this case above, so we'll
            // trigger an assertion failure here.
            assertionFailure("Should have logged out")
            return Alert(title: Text("Logging out..."))
        }
    }
}
