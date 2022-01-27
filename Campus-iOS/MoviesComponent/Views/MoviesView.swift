//
//  MoviesView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct MoviesView: View {
    
    @ObservedObject var viewModel = MoviesViewModel()
    
    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: items, spacing: 6) {
                ForEach(self.viewModel.movies, id: \.id) { movie in
                    MovieCard(movie: movie).padding(10)
                }
            }.padding(15)
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
