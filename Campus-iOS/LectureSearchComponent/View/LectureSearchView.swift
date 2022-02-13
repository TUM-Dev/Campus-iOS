//
//  LectureSearchView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import SwiftUI

struct LectureSearchView: View {
    
    @ObservedObject var viewModel = LectureSearchViewModel()
    @State var searchText = ""
    
    var body: some View {
        List {
            ForEach(self.viewModel.result) { lecture in
                NavigationLink(
                    destination: LectureDetailsScreen(lecture: lecture)
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
            if(viewModel.errorMessage != "") {
                VStack {
                    Spacer()
                    Text(self.viewModel.errorMessage).foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: self.searchText) { searchValue in
            if(searchValue.count > 3) {
                self.viewModel.fetch(searchString: searchValue)
            }
        }
        .animation(.default, value: self.viewModel.result)
    }
}

struct LectureSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LectureSearchView()
    }
}
