//
//  MoviesView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct MoviesView: View {
    
    @ObservedObject var viewModel = MoviesViewModel()
    
    var body: some View {
        ForEach(self.viewModel.movies, id: \.id) { movie in
            Text(movie.title ?? "")
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
