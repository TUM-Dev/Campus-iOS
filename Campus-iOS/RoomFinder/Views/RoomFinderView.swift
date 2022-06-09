//
//  RoomFinderView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 17.05.22.
//

import SwiftUI

struct RoomFinderView: View {
    
    @StateObject var model: Model
    @ObservedObject var viewModel = RoomFinderViewModel()
    @State var searchText = ""
    
    var body: some View {
        RoomFinderListView(model: self.model, viewModel: self.viewModel)
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

struct RoomFinderView_Previews: PreviewProvider {
    static var previews: some View {
        RoomFinderView(model: MockModel())
    }
}
