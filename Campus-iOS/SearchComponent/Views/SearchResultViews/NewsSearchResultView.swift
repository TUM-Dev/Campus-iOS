//
//  NewsSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation
import SwiftUI

struct NewsSearchResultView: View {
    @StateObject var vm: NewsSearchResultViewModel
    @Binding var query: String
    
    @State var newsLink: URL? = nil
    @State var selectedMovie: Movie? = nil
    
    @State var size: ResultSize = .small
    
    var newsResults: [(news: News, distance: Distances)] {
        switch size {
        case .small:
            return Array(vm.newsResults.prefix(3))
        case .big:
            return Array(vm.newsResults.prefix(10))
        }
    }
    
    var movieResults: [(movie: Movie, distance: Distances)] {
        switch size {
        case .small:
            return Array(vm.movieResults.prefix(3))
        case .big:
            return Array(vm.movieResults.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Group {
                            switch vm.vmType {
                            case .news:
                                Text("News").fontWeight(.bold)
                            case .movie:
                                Text("Movies").fontWeight(.bold)
                            }
                        }
                        .font(.title)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
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
                ScrollView {
                    ///** The following code is for all newsSources. Currently we only use TUMOnline due to lagginess **
                    //                ForEach(vm.results, id: \.newsResult) { result in
                    //                    VStack {
                    //                        Text(result.newsResult.title ?? "")
                    //                        ForEach(result.newsResult.news, id: \.id) { news in
                    //                            Text(news.title ?? "")
                    //                        }
                    //                    }
                    //                }
                    switch vm.vmType {
                    case .news:
                        ForEach(newsResults, id: \.news) { result in
                            HStack {
                                Button {
                                    self.newsLink = result.news.link
                                } label: {
                                    Text(result.news.title ?? "")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                }
                                Spacer()
                            }
                        }.sheet(item: $newsLink) { selectedLink in
                            if let link = selectedLink {
                                SFSafariViewWrapper(url: link)
                            }
                        }
                    case .movie:
                        ForEach(movieResults, id: \.movie) { result in
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
                            if let movie = selectedMovie {
                                MovieDetailedView(movie: movie)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: query) { newQuery in
            Task {
                await vm.newsSearch(for: newQuery)
            }
        }.task {
            await vm.newsSearch(for: query)
        }
    }
}

struct NewsSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news, newsService: NewsService_Preview()), query: .constant("news test"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct MovieSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie, movieService: MovieService_Preview()), query: .constant("news test"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}


struct NewsService_Preview: NewsServiceProtocol {
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News] {
        return News.previewData
    }
}

struct MovieService_Preview: MovieServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Movie] {
        return Movie.previewData
    }
}
//
