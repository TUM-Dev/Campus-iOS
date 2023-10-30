//
//  TUMSexyScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import SwiftUI

struct TUMSexyScreen: View {
    @StateObject var vm = TUMSexyViewModel()
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let links):
                VStack {
                    TUMSexyView(links: links)
                    .refreshable {
                        await vm.getLinks(forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Links")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getLinks
                )
            }
        }.task {
            await vm.getLinks()
        }
    }
}
