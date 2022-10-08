//
//  MoviesView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct MoviesView: View {
    
    @ObservedObject var viewModel = MoviesViewModel()
    @State private var selectedMovie: Movie? = nil

    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        ZStack {
            Text("No more movies this semester 😢\nGet excited for the next season!")
                .foregroundColor(Color(UIColor.lightGray))
            ScrollView(.vertical) {
                LazyVGrid(columns: items, spacing: 6) {
                    ForEach(self.viewModel.movies, id: \.id ) { movie in
                            MovieCard(movie: movie).padding(10)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                    .sheet(item: $selectedMovie) { movie in
                        MovieDetailedView(movie: movie)
                    }
                }
                .padding(15)
                .background(Color.systemsBackground)
            }
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
