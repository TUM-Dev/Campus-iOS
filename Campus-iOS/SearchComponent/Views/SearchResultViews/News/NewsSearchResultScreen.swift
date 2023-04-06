//
//  NewsSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct NewsSearchResultScreen: View {
    @StateObject var vm: NewsSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                NewsSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Movies")
            case .failed(let error):
                SearchResultErrorView(title: "Movies", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.newsSearch(for: newQuery)
            }
        }.task {
            await vm.newsSearch(for: query)
        }
    }
}

struct NewsSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsSearchResultScreen(vm: NewsSearchResultViewModel(service: NewsService_Preview()), query: .constant("news test"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct NewsService_Preview: NewsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [NewsSource] {
        return NewsSource.previewData
    }
    
    func fetch(forcedRefresh: Bool, source: String) async throws -> [News] {
        return News.previewData
    }
}
