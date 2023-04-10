//
//  RoomFinderSearchView.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import SwiftUI

struct RoomFinderSearchResultView: View {
    let allResults: [NavigaTumNavigationEntity]
    @State var size: ResultSize = .small
    
    var results: [NavigaTumNavigationEntity] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Text("NavigaTUM")
                            .fontWeight(.bold)
                            .font(.title)
                        HStack {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
                                        self.size = .big
                                    }
                                }
                            } label: {
                                if self.size == .small {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                } else {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(results, id:\.id) { room in
                            NavigationLink(
                                destination: NavigaTumDetailsView(viewModel: NavigaTumDetailsViewModel(id: room.id))
                            ) {
                                Text(room.name).padding()
                            }
                        }
                    }
                }
                if self.results.count == 0 {
                    Text("No rooms were found 😢")
                        .foregroundColor(.gray)
                }
            }.padding()
        }
    }
}
