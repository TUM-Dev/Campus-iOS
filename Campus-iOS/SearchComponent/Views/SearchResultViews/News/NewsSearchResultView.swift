//
//  NewsSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import SwiftUI

struct NewsSearchResultView: View {
    let allResults: [(news: News, distance: Distances)]
    @State var newsLink: URL? = nil
    @State var size: ResultSize = .small
    
    var results: [(news: News, distance: Distances)] {
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
                        Text("News").fontWeight(.bold)
                            .font(.title)
                        ExpandIcon(size: $size)
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
                    ForEach(results, id: \.news) { result in
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
                        SFSafariViewWrapper(url: selectedLink)
                    }
                }
            }
        }
    }
}
