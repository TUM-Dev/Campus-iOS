//
//  MovieSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct ExpandIcon: View {
    @Binding var size: ResultSize
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button {
                withAnimation {
                    switch size {
                    case .big:
                        self.size = .small
                    case .small:
                        self.size = .big
                    }
                }
            } label: {
                if self.size == .small {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .padding()
                } else {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                        .padding()
                }
            }
        }
    }
}

struct MovieSearchResultView: View {
    let allResults: [(movie: Movie, distance: Distances)]
    
    @State var newsLink: URL? = nil
    @State var selectedMovie: Movie? = nil
    
    @State var size: ResultSize = .small
    
    var results: [(movie: Movie, distance: Distances)] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Text("Movies").fontWeight(.bold)
                        .font(.title)
                        ExpandIcon(size: $size)
                    }
                }
                if results.isEmpty {
                    Text("No more movies this semester 😢\nGet excited for the next season!")
                        .padding()
                } else {
                    ScrollView {
                        ForEach(results, id: \.movie) { result in
                            HStack {
                                Button {
                                    self.selectedMovie = result.movie
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(result.movie.title ?? "")
                                            .fontWeight(.bold)
                                        Text(result.movie.genre ?? "")
                                            .fontWeight(.light)
                                            .foregroundColor(.gray)
                                    }
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                }
                                Spacer()
                            }
                        }.sheet(item: $selectedMovie) { selectedMovie in
                            MovieDetailedView(movie: selectedMovie)
                        }
                    }
                }
            }
        }
    }
}
