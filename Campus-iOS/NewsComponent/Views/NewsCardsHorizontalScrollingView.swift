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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(news, id: \.id) { news in
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
            }
            .padding([.top, .leading], 30)
        }
    }
}

struct NewsCardsHorizontalScrollingView_Previews: PreviewProvider {
    
    static let news = News(id: "1", sourceId: 1, date: Date(), created: Date(), title: "Dummy Title", link: URL(string: "https://github.com/orgs/TUM-Dev"), imageURL: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg")
    
    static var previews: some View {
        NewsCardsHorizontalScrollingView(news: [news, news])
    }
}
