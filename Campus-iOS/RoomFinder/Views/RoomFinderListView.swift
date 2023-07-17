//
//  RoomFinderListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 17.05.22.
//

import SwiftUI

struct RoomFinderListView: View {
    
    @StateObject var model: Model
    @Environment(\.isSearching) private var isSearching
    @ObservedObject var viewModel: RoomFinderViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.result, id: \.id) { room in
                RoomFinderListCellView(room: room)
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

struct RoomFinderListCellView: View {
    let room: FoundRoom
    
    var body: some View {
        NavigationLink(
            destination: RoomFinderDetailsView(room: room)
                .navigationBarTitleDisplayMode(.inline)
        ) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(room.info)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(room.roomCode)
                            .foregroundColor(Color(.secondaryLabel))
                        Spacer().frame(width: 5)
                        Text(room.purpose)
                            .font(.footnote)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                Spacer()
            }.padding()
        }
    }
}

struct RoomFinderListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomFinderListView(model: MockModel(), viewModel: RoomFinderViewModel())
    }
}
