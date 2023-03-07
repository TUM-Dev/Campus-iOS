//
//  SwiftUIView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct MovieSearchResultScreen: View {
    @StateObject var vm: MovieSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                MovieSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Movies")
            case .failed(let error):
                SearchResultErrorView(title: "Movies", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.movieSearch(for: newQuery)
            }
        }.task {
            await vm.movieSearch(for: query)
        }
    }
}

struct MovieSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchResultScreen(vm: MovieSearchResultViewModel(service: MovieService_Preview()), query: .constant("news test"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct MovieService_Preview: MovieServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Movie] {
        return Movie.previewData
    }
}
