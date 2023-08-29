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
        VStack {
            VStack {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text("NavigaTUM")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                    ExpandIcon(size: $size)
                }
                Divider()
            }
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(results, id:\.id) { room in
                        NavigationLink(
                            destination: RoomDetailsScreen(room: room))
                        {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "graduationcap.circle")
                                        .resizable()
                                        .foregroundColor(Color.highlightText)
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                    Text(room.name)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                                }
                                .padding(.horizontal, 5)
                                .foregroundColor(Color.primaryText)
                                if room != results.last {
                                    Divider()
                                }
                            }
                        }
                    }
                }.padding(.top, 10)
            }
            if self.results.count == 0 {
                Text("No rooms were found 😢")
                    .foregroundColor(.gray)
            }
        }
    }
}
