//
//  MoviesWidgetView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.01.23.
//

import SwiftUI

struct MoviesWidgetView: View {
    
    let movies: [Movie]
    @State private var selectedMovie: Movie? = nil
    
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("TU Film").titleStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies, id: \.id ) { movie in
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
