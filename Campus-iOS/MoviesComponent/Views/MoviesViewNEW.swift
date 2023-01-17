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
        if viewModel.isFetched {
            VStack(spacing: 0) {
                HStack {
                    Text("TU Film")
                        .font(.headline.bold())
                        .textCase(.uppercase)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                }
                .padding(.leading, 40)
                .padding(.bottom, 5)
                
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
                    .padding(.leading)
                    .padding(.trailing)
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct MoviesViewNEW_Previews: PreviewProvider {
    static var previews: some View {
        MoviesViewNEW()
    }
}
