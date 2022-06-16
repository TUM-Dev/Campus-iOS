//
//  PersonSearchView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import SwiftUI

struct PersonSearchView: View {
    
    @Environment(\.isSearching) private var isSearching
    
    @ObservedObject var viewModel = PersonSearchViewModel()
    @State var searchText = ""
    
    var body: some View {
        PersonSearchListView(viewModel: self.viewModel)
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: self.searchText) { searchValue in
                if searchValue.count > 3 {
                    self.viewModel.fetch(searchString: searchValue)
                }
            }
            .animation(.default, value: self.viewModel.result)
    }
}

struct PersonSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSearchView()
    }
}
