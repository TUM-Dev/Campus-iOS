//
//  PersonSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

@MainActor
struct PersonSearchResultScreen: View {
    @StateObject var vm: PersonSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                PersonSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Person Search")
            case .failed(let error):
                SearchResultErrorView(title: "Person Search", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.personSearch(for: newQuery)
            }
        }
        .task {
            await vm.personSearch(for: query)
        }
    }
}
