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
    
    var body: some View {
        ZStack {
            Color.white
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
                    ForEach(vm.newsResults, id: \.news) { result in
                        Text(result.news.title ?? "")
                    }
                case .movie:
                    ForEach(vm.movieResults, id: \.movie) { result in
                        HStack {
                            Text(result.movie.title ?? "")
                            Text(result.movie.genre ?? "")
                        }
                    }
                }
                
            }
        }
        .onChange(of: query) { newQuery in
            Task {
                await vm.newsSearch(for: newQuery)
            }
        }.onAppear() {
            Task {
                await vm.newsSearch(for: query)
            }
        }
    }
}
