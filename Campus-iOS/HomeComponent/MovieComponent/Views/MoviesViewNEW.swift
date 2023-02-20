//
//  MoviesViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.01.23.
//

import SwiftUI

struct MoviesViewNEW: View {
    
    @ObservedObject var viewModel = MoviesViewModel()
    @State private var selectedMovie: Movie? = nil
    
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        switch self.viewModel.state {
        case .failed:
            EmptyView()
        case .noMovies:
            EmptyView()
        case .loading:
            ProgressView()
        case .success:
            VStack(spacing: 0) {
                Text("TU Film").titleStyle()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.viewModel.movies, id: \.id ) { movie in
                            MovieCard(movie: movie).padding(7)
                                .onTapGesture {
                                    selectedMovie = movie
                                }
                        }
                        .sheet(item: $selectedMovie) { movie in
                            MovieDetailedView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct MoviesViewNEW_Previews: PreviewProvider {
    static var previews: some View {
        MoviesViewNEW()
    }
}
