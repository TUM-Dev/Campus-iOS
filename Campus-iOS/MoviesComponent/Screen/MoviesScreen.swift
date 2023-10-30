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
        }
    }
}
