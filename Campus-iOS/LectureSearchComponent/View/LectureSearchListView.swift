//
//  LectureSearchListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct LectureSearchListView: View {
    @StateObject var model: Model
    @Environment(\.isSearching) private var isSearching
    @ObservedObject var viewModel: LectureSearchViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.result) { lecture in
                NavigationLink(
                    destination: LectureDetailsScreen(model: self.model, lecture: lecture)
                                    .navigationBarTitleDisplayMode(.inline)
                ) {
                    HStack {
                        Text(lecture.title)
                        Spacer()
                        Text(lecture.eventType)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            if viewModel.errorMessage != "" {
                VStack {
                    Spacer()
                    Text(self.viewModel.errorMessage).foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .onChange(of: isSearching) { newValue in
            if !newValue {
                self.viewModel.result = []
            }
        }
    }
}

struct LectureSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        LectureSearchListView(model: MockModel(), viewModel: LectureSearchViewModel())
    }
}
