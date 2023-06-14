//
//  MoviesView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
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
                        MoviesWidgetView(movies: movies)
                    } else {
                        MoviesView(movies: movies)
                            .refreshable {
                                await vm.getMovies(forcedRefresh: true)
                            }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching News")
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

struct MoviesView: View {
    let movies: [Movie]
    @State private var selectedMovie: Movie? = nil
    
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        ZStack {
            Text("No more movies this semester 😢\nGet excited for the next season!")
                .foregroundColor(Color(UIColor.lightGray))
            ScrollView(.vertical) {
                LazyVGrid(columns: items, spacing: 10) {
                    ForEach(self.movies, id: \.id ) { movie in
                        MovieCard(movie: movie).padding(7)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                    .sheet(item: $selectedMovie) { movie in
                        MovieDetailedView(movie: movie)
                    }
                }
                .padding(10)
                .background(Color.systemsBackground)
            }
        }
    }
}

//struct MoviesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesView()
//    }
//}
