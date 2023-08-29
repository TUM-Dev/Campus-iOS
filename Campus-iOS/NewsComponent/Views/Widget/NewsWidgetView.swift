//
//  NewsWidgetView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 22.02.23.
//

import SwiftUI

struct NewsWidgetView: View {
    
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    @State var selectedLink: URL? = nil
    let latestFiveNews: [(String?, News?)]
    
    var body: some View {
        VStack(spacing: 0){
            Text("Latest News").titleStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(self.latestFiveNews, id: \.1?.id) { article in
                        if let url = article.1?.link {
                            if self.useBuildInWebView {
                                NewsCard(news: article, latest: true)
                                    .onTapGesture {
                                        self.selectedLink = url
                                    }
                            } else {
                                Link(destination: url) {
                                    NewsCard(news: article, latest: true)
                                }
                            }
                        }
                    }.sheet(item: $selectedLink) { selectedLink in
                            SFSafariViewWrapper(url: selectedLink)
                    }
                }.padding(.horizontal, 20)
            }
        }
    }
}
