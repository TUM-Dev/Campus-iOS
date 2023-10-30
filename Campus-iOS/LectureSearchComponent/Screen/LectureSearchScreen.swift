//
//  LectureSearchView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import SwiftUI

struct LectureSearchScreen: View {
    @StateObject var vm: LectureSearchViewModel
    @State var searchText = ""
    
    init(model: Model) {
        self._vm = StateObject(wrappedValue: LectureSearchViewModel(model: model, service: LectureSearchService()))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let lectures):
                VStack {
                    LectureSearchView(model: vm.model, lectures: lectures)
                        .background(Color(.systemGroupedBackground))
                }
            case .loading:
                if searchText.count > 3 {
                    LoadingView(text: "Fetching Lectures")
                } else {
                    Text("The search query must be at least 4 characters.")
                }
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: {_ in await vm.getLectures(for: self.searchText, forcedRefresh: true)}
                )
            case .na:
                if searchText.count > 0 && searchText.count <= 3 {
                    Text("The search query must be at least 4 characters.")
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: self.searchText) { query in
            Task {
                await vm.getLectures(for: query, forcedRefresh: true)
            }
        }
    }
}

//struct LectureSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        LectureSearchView(model: MockModel())
//    }
//}
