//
//  MovieScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import SwiftUI

struct MovieScreen: View {
    @StateObject var vm = MovieViewModel()
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let movies):
                VStack {
                    MovieView(movies: movies)
                    .refreshable {
                        await vm.getMovies(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching News")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getMovies
                )
            }
        }.task {
            await vm.getMovies()
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
