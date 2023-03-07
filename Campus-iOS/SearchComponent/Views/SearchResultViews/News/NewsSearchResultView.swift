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
                        if let link = selectedLink {
                            SFSafariViewWrapper(url: link)
                        }
                    }
                }
            }
        }
    }
}
