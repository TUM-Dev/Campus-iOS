//
//  GradeSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct GradesSearchResultScreen: View {
    @StateObject var vm: GradesSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                GradesSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Grades")
            case .failed(let error):
                SearchResultErrorView(title: "Grades", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.gradesSearch(for: newQuery)
            }
        }
        .task {
            await vm.gradesSearch(for: query)
        }
    }
}
