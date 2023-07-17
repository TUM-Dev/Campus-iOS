//
//  RoomFinderSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

@MainActor
struct RoomFinderSearchResultScreen: View {
    @StateObject var vm: RoomFinderSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                RoomFinderSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "RoomFinder")
            case .failed(let error):
                SearchResultErrorView(title: "RoomFinder", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.roomFinderSearch(for: newQuery)
            }
        }.task {
            await vm.roomFinderSearch(for: query)
        }
    }
}
