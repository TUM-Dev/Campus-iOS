//
//  NewsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 20.01.22.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject var viewModel: NewsViewModel
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @Environment(\.scenePhase) var scenePhase
    @State var isWebViewShowed = false
    @State var selectedLink: URL? = nil
    
    var body: some View {
//        ScrollView(.vertical) {
//            VStack(alignment: .center) {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 30) {
//                        ForEach(viewModel.latestFiveNews, id: \.1?.id) { oneLatestNews in
//                            GeometryReader { geometry in
//                                if let url = oneLatestNews.1?.link {
//                                    if self.useBuildInWebView {
//                                        NewsCard(news: oneLatestNews, latest: true)
//                                            .padding()
//                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
//                                            .onTapGesture {
//                                                self.selectedLink = oneLatestNews.1?.link
//                                            }
//                                    } else {
//                                        Link(destination: url) {
//                                            NewsCard(news: oneLatestNews, latest: true)
//                                                .padding()
//                                                .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
//                                        }
//                                    }
//                                }
//                            }
//                            .frame(width: 250, height: 350)
//                            // adjust height
//                            Spacer(minLength: 1)
//                        }.sheet(item: $selectedLink) { selectedLink in
//                            if let link = selectedLink {
//                                SFSafariViewWrapper(url: link)
//                            }
//                        }
//                        Spacer()
//                    }.padding()
//                }
//
//
//
//                Spacer()
//                ForEach(viewModel.newsSources.filter({!$0.news.isEmpty && $0.id != 2}), id: \.id) { source in
//                    Collapsible(title: {
//                        AnyView(HStack(alignment: .center) {
//                            Image(systemName: "list.bullet").foregroundColor(.blue)
//                            Text(source.title ?? "")
//                                .fontWeight(.bold)
//                                .font(.headline)
//                        })
//                    }) {
//                        NewsCardsHorizontalScrollingView(news: source.news)
//                    }.modifier(ScrollableCardsViewModifier())
//                }
//            }
//        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
//            print("UIApplication: active")
//            viewModel.fetch()
//          }
        
//        List(viewModel.newsSources.filter({$0.id != 2}), id: \.id) { newsSource in
//            Section(newsSource.title ?? "NIL") {
//                ForEach(newsSource.news, id: \.id) { news in
//                    Text(news.title ?? "NIL")
//                }
//            }
//        }
        
        
//        List(viewModel.news, id: \.id) { news in
//            Text(news.title ?? "NIL")
//        }

        List(viewModel.sourcesAndNews, id: \.0) { sourceAndNews in
            Section(String(sourceAndNews.0 ?? 0)) {
                ForEach(sourceAndNews.1, id: \.id) { news in
                    Text(news.title ?? "NIL")
                }
            }
        }
    }
}


struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = MockNewsViewModel()
        NewsView(viewModel: vm)
    }
}
