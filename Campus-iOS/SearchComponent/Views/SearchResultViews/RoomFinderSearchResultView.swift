//
//  RoomFinderSearchView.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation
import SwiftUI

struct RoomFinderSearchResultView: View {
    @StateObject var vm = RoomFinderSearchResultViewModel()
    @Binding var query: String
    
    @State var size: ResultSize = .small
    
    var results: [FoundRoom] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Text("RoomFinder")
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
                    ForEach(results, id:\.id) { room in
                        RoomFinderListCellView(room: room)
                    }
                }
                if self.results.count == 0 {
                    Text("No rooms were found 😢")
                        .foregroundColor(.gray)
                }
            }.padding()
        }.onChange(of: query) { newQuery in
            Task {
                await vm.roomFinderSearch(for: newQuery)
            }
        }.onAppear() {
            Task {
                await vm.roomFinderSearch(for: query)
            }
        }
        
    }
}
