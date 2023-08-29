//
//  StudyRoomSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct StudyRoomSearchResultView: View {
    var allResults: [(studyRoomResult: StudyRoomSearchResult, distance: Distances)]
    @State var showRoomsForGroup: [StudyRoom]? = nil
    @State var size: ResultSize = .small
    
    var results: [(studyRoomResult: StudyRoomSearchResult, distance: Distances)] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Image(systemName: "pencil.circle")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text("Study Rooms")
                        .lineLimit(1)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                    ExpandIcon(size: $size)
                }
                Divider()
            }
            ScrollView {
                ForEach(results, id: \.studyRoomResult) { result in
                    NavigationLink(destination: StudyRoomGroupView(
                        vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                        selectedGroup: result.studyRoomResult.group,
                        rooms: result.studyRoomResult.rooms,
                        canDismiss: false
                    )) {
                        VStack {
                            HStack {
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .foregroundColor(Color.highlightText)
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                Text(result.studyRoomResult.group.name ?? "no group name")
                                    .foregroundColor(Color.primaryText)
                                    .multilineTextAlignment(.leading)
                                let freeRooms = result.studyRoomResult.rooms.filter{ $0.isAvailable() }.count
                                if freeRooms > 0 {
                                    Spacer()
                                    Text("\(freeRooms) rooms free").foregroundColor(.green)
                                } else {
                                    Spacer()
                                    Text("No rooms free").foregroundColor(.red)
                                }
                                Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                            }
                            .padding(.horizontal, 5)
                            if results.last != nil {
                                if result != results.last! {
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }.padding(.top, 10)
        }
    }
}

struct GroupDirectionsButton<Content: View>: View {
    let group: StudyRoomGroup
    let content: Content
    
    init(group: StudyRoomGroup, @ViewBuilder content: () -> Content) {
        self.group = group
        self.content = content()
    }
    
    var body: some View {
        Button {
            let latitude = group.coordinate?.latitude
            let longitude = group.coordinate?.longitude
            let url = URL(string: "maps://?saddr=&daddr=\(latitude!),\(longitude!)")
            
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        } label: {
            self.content
                .foregroundColor(.blue)
                .font(.footnote)
        }
    }
}

struct StudyRoomCell: View {
    
    let room: StudyRoom
    
    var body: some View {
        DisclosureGroup(content: {
            StudyRoomDetailsScreen(room: room)
        }, label: {
            AnyView(
                HStack {
                    VStack(alignment: .leading) {
                        Text(room.name ?? "")
                            .fontWeight(.bold)
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color("tumBlue"))
                            Text(room.code ?? "")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.init(.darkGray))
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .padding(.top, 0)
                        .padding(.bottom, 0)
                    }
                    
                    Spacer()
                    
                    room.localizedStatusText
                }
            )
        })
        .accentColor(Color(UIColor.lightGray))
    }
}
