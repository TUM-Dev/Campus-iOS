//
//  NewsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 20.01.22.
//

import SwiftUI

struct NewsView: View {
    
    @ObservedObject var viewModel = NewsViewModel()
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                if let url = self.viewModel.latestNews.1?.link {
                    if self.useBuildInWebView {
                        NewsCard(news: self.viewModel.latestNews, latest: true)
                            .onTapGesture {
                                self.isWebViewShowed.toggle()
                            }
                            .sheet(isPresented: $isWebViewShowed) {
                                SFSafariViewWrapper(url: url)
                            }
                    } else {
                        Link(destination: url) {
                            NewsCard(news: self.viewModel.latestNews, latest: true)
                        }
                    }
                }
                Spacer(minLength: 20)
                ForEach(viewModel.newsSources.filter({!$0.news.isEmpty && $0.id != 2}), id: \.id) { source in
                    Collapsible(title: {
                        AnyView(HStack(alignment: .center) {
                            Image(systemName: "list.bullet").foregroundColor(.blue)
                            Text(source.title ?? "")
                                .fontWeight(.bold)
                                .font(.headline)
                        })
                    }) {
                        NewsCardsHorizontalScrollingView(news: source.news)
                    }.modifier(ScrollableCardsViewModifier())
                }
            }
        }
    }
}


struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
