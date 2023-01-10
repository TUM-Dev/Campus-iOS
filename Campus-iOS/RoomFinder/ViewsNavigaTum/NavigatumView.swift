//
//  NavigaTumView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 06.01.23.
//

import SwiftUI

struct NavigaTumView: View {
    @ObservedObject var model: Model
    @StateObject var viewModel = NavigaTumViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigaTumListView(model: self.model, viewModel: self.viewModel)
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: self.searchText) { searchValue in
                if searchValue.count > 3 {
                    Task {
                        await search(searchValue)
                    }
                }
            }
            .task {
                if !searchText.isEmpty {
                    await search(searchText)
                }
            }
            .animation(.default, value: self.viewModel.searchResults)
    }
    
    func search(_ searchValue: String) async {
        await self.viewModel.fetch(searchString: searchValue)
    }
}

struct NavigaTumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigaTumView(model: MockModel())
    }
}
