//
//  TUMSexyScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import SwiftUI

struct TUMSexyScreen: View {
    @StateObject var vm = TUMSexyViewModel2()
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let links):
                VStack {
                    TUMSexyView(links: links)
                    .refreshable {
                        await vm.getLinks(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Links")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getLinks
                )
            }
        }.onAppear {
            Task {
                await vm.getLinks()
            }
        }
        .alert(
            "Error while fetching Links",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getLinks(forcedRefresh: true)
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMSexyAPIError {
                        Text(apiError.errorDescription ?? "TUMSexyAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}
