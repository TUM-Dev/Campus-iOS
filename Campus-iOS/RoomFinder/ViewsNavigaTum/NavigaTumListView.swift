//
//  NavigatumListView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 06.01.23.
//

import SwiftUI

struct NavigaTumListView: View {
    @StateObject var model: Model
    @Environment(\.isSearching) private var isSearching
    @ObservedObject var viewModel: NavigaTumViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.searchResults) { entry in
                NavigationLink(
                    destination: NavigaTumDetailsView(viewModel: NavigaTumDetailsViewModel(id: entry.id))
                ) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(entry.name)
                        }
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
                self.viewModel.searchResults = []
            }
        }
    }
}

struct NavigatumListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigaTumListView(model: MockModel(), viewModel: NavigaTumViewModel())
    }
}
