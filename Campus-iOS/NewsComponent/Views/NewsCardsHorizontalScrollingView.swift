//
//  NewsCardsHorizontalScrollingView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct NewsCardsHorizontalScrollingView: View {
    
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    @State var news: [News]
    @State var visibleNews: [News]
    @State var showLoadButton = true
    
    var sortedNews: [News] = []
    
    init(news: [News]) {
        sortedNews = news.sorted(by: { news1, news2 in
            if let date1 = news1.created, let date2 = news2.created {
                return date1.compare(date2) == .orderedDescending
            } else {
                return false
            }
        })
        
        self.news = sortedNews
        
        visibleNews = Array(sortedNews.prefix(upTo: 5))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(visibleNews, id: \.id) { news in
                    GeometryReader { geometry in
                        if let link = news.link {
                            if self.useBuildInWebView {
                                NewsCard(news: (nil, news), latest: false)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
                                    .onTapGesture {
                                        self.isWebViewShowed.toggle()
                                    }
                                    .sheet(isPresented: $isWebViewShowed) {
                                        SFSafariViewWrapper(url: link)
                                    }
                            } else {
                                Link(destination: link) {
                                    NewsCard(news: (nil, news), latest: false)
                                        .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }
                    .frame(width: 250, height: 250)
                    Spacer(minLength: 1)
                }
                
                if visibleNews.count < sortedNews.count {
                    GeometryReader { geometry in
                        
                        LoadMoreCard(loadingMethod: {
                            // Amount of how many news are still hidden
                            let diffAmount = sortedNews.count - visibleNews.count
                            
                            if diffAmount > 0 {
                                // If the diff is >= 5 than append the next 5 news. Otherwise (diff < 5) just append the last e.g. 2 news. (In this example: diffAmount = 2)
                                // The -1 is neccessary due to the counting: We start from visibleNews.count to (visibleNews.count + 5 - 1) in order to get the next 5 news
                                visibleNews.append(contentsOf: sortedNews[visibleNews.count...(visibleNews.count + (diffAmount >= 5 ? 5 : diffAmount) - 1)])
                            }
                        })
                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
                                
                    }
                    .frame(width: 150, height: 250)
                    Spacer(minLength: 1)
                }
            }
            .padding([.top, .leading], 30)
        }
    }
}

struct NewsCardsHorizontalScrollingView_Previews: PreviewProvider {
    
    static let news = News(id: "1", sourceId: 1, date: Date(), created: Date(), title: "Dummy Title", link: URL(string: "https://github.com/orgs/TUM-Dev"), imageURL: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg")
    
    static var previews: some View {
        NewsCardsHorizontalScrollingView(news: [news, news, news, news, news])
    }
}
