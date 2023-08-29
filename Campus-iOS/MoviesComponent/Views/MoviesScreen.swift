//
//  MoviesScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 15.06.23.
//

import SwiftUI

struct MoviesScreen: View {
    @StateObject var vm = MoviesViewModel()
    let isWidget: Bool
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let movies):
                VStack {
                    if isWidget {
                        if !movies.isEmpty {
                            MoviesWidgetView(movies: movies)
                                .padding(.bottom)
                        }
                    } else {
                        MoviesView(movies: movies)
                            .refreshable {
                                await vm.getMovies(forcedRefresh: true)
                            }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Movies")
                    .padding(.vertical)
            case .failed(let error):
                if isWidget {
                    EmptyView()
                } else {
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getMovies
                    )
                }
            }
        }.task {
            await vm.getMovies(forcedRefresh: true)
        }.alert(
            "Error while fetching News",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getMovies(forcedRefresh: true)
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMCabeAPIError {
                        Text(apiError.errorDescription ?? "TUMCabeAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}
