//
//  LectureSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct LectureSearchResultScreen: View {
    @StateObject var vm: LectureSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                LectureSearchResultView(allResults: data, model: vm.model, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Lectures")
            case .failed(let error):
                SearchResultErrorView(title: "Lectures", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.lectureSearch(for: newQuery)
            }
        }.task {
            await vm.lectureSearch(for: query)
        }
    }
}
