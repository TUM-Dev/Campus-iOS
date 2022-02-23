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
        LectureSearchListView(viewModel: self.viewModel)
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
