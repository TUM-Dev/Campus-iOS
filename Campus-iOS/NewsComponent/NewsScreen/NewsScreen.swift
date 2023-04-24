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
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getNewsSources
                )
            }
        }.task {
            await vm.getNewsSources()
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
