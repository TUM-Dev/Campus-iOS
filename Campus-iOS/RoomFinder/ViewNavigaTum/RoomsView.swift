//
//  RoomsView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.06.23.
//

import SwiftUI

struct RoomsView: View {
    
    @StateObject var vm: AnnotatedMapViewModel //errror handling?
    
    var body: some View {
        if !vm.rooms.isEmpty {
            Group {
                Label("Most Searched Rooms", systemImage: "door.right.hand.closed").titleStyle()
                    .padding(.top, 20)
                
                VStack {
                    ForEach(vm.rooms) { entry in
                        NavigationLink(
                            destination: NavigaTumDetailsView(viewModel: NavigaTumDetailsViewModel(id: entry.id))
                        ) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "graduationcap.circle")
                                        .resizable()
                                        .foregroundColor(Color.highlightText)
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                    Text(entry.name)
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                                }
                                .padding(.horizontal, 5)
                                .foregroundColor(Color.primaryText)
                                if entry != vm.rooms.last {
                                    Divider()
                                }
                            }
                        }
                        .task {
                            let tempVm = NavigaTumDetailsViewModel(id: entry.id)
                            await tempVm.fetchDetails()
                        }
                    }
                }
                .sectionStyle()
            }
        }
    }
}
