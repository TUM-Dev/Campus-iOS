//
//  NewsScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import SwiftUI

struct NewsScreen: View {
    @StateObject var vm = NewsViewModel()
    let isWidget: Bool
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let newsSources):
                if isWidget {
                    NewsWidgetView(latestFiveNews: vm.latestFiveNews)
                } else {
                    VStack {
                        NewsView(latestFiveNews: vm.latestFiveNews, newsSources: newsSources)
                            .refreshable {
                                await vm.getNewsSources(forcedRefresh: true)
                            }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching News")
                    .padding(.vertical)
            case .failed(let error):
                if isWidget {
                    EmptyView()
                } else {
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getNewsSources
                    )
                }
            }
        }.task {
            await vm.getNewsSources(forcedRefresh: true)
        }
    }
}
