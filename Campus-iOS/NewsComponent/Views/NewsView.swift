//
//  NewsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 20.01.22.
//

import SwiftUI

struct NewsScreen: View {
    @StateObject var vm = NewsViewModel()
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let newsSources):
                VStack {
                    NewsView(latestFiveNews: vm.latestFiveNews, newsSources: newsSources)           .refreshable {
                        await vm.getNewsSources(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching News")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getNewsSources
                )
            }
        }.onAppear {
            Task {
                await vm.getNewsSources()
            }
        }.alert(
            "Error while fetching News",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getNewsSources(forcedRefresh: true)
                    }
                }
        
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMCabeAPIError {
                        Text(apiError.errorDescription ?? "TUMCabeAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}

struct NewsView: View {
    
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @Environment(\.scenePhase) var scenePhase
    @State var isWebViewShowed = false
    @State var selectedLink: URL? = nil
    
    let latestFiveNews: [(String?, News?)]
    let newsSources: [NewsSource]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(latestFiveNews, id: \.1?.id) { oneLatestNews in
                            GeometryReader { geometry in
                                if let url = oneLatestNews.1?.link {
                                    if self.useBuildInWebView {
                                        NewsCard(news: oneLatestNews, latest: true)
                                            .padding()
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
                                            .onTapGesture {
                                                self.selectedLink = oneLatestNews.1?.link
                                            }
                                    } else {
                                        Link(destination: url) {
                                            NewsCard(news: oneLatestNews, latest: true)
                                                .padding()
                                                .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 50) / -20), axis: (x: 0, y: 100.0, z: 0))
                                        }
                                    }
                                }
                            }
                            .frame(width: 250, height: 350)
                            // adjust height
                            Spacer(minLength: 1)
                        }.sheet(item: $selectedLink) { selectedLink in
                            if let link = selectedLink {
                                SFSafariViewWrapper(url: link)
                            }
                        }
                        Spacer()
                    }.padding()
                }

                Spacer()
                
                ForEach(newsSources.filter({!$0.news.isEmpty && $0.id != 2}), id: \.id) { source in
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
