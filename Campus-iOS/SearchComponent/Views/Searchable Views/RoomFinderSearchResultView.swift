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
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(self.vm.results, id:\.id) { room in
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
                }
            }
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
