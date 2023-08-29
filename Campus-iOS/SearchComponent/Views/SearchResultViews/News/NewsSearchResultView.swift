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
        VStack {
            VStack {
                HStack {
                    Image(systemName: "newspaper")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text("News")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                    ExpandIcon(size: $size)
                }
                Divider().padding(.horizontal)
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
                    Button {
                        self.newsLink = result.news.link
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "newspaper.circle")
                                    .resizable()
                                    .foregroundColor(Color.highlightText)
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                Text(result.news.title ?? "")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                            }
                            .padding(.horizontal, 5)
                            .foregroundColor(Color.primaryText)
                            if results.last != nil {
                                if result != results.last! {
                                    Divider()
                                }
                            }
                        }
                    }
                }.sheet(item: $newsLink) { selectedLink in
                    SFSafariViewWrapper(url: selectedLink)
                }
            }
        }
    }
}
