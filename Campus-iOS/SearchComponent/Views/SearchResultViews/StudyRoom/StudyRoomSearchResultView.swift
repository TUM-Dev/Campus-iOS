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
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                VStack {
                    ZStack {
                        Text("Study Rooms")
                            .fontWeight(.bold)
                            .font(.title)
                        ExpandIcon(size: $size)
                    }
                }
                ScrollView {
                    ForEach(results, id: \.studyRoomResult) { result in
                        VStack (alignment: .leading) {
                            HStack {
                                Text(result.studyRoomResult.group.name ?? "no group name")
                                    .fontWeight(.heavy)
                                Spacer()
                                GroupDirectionsButton(group: result.studyRoomResult.group) {
                                    Image(systemName: "mappin.and.ellipse")
                                }
                            }
                            Button {
                                withAnimation {
                                    self.showRoomsForGroup = showRoomsForGroup == result.studyRoomResult.rooms ? nil : result.studyRoomResult.rooms
                                }
                            } label: {
                                if showRoomsForGroup == result.studyRoomResult.rooms {
                                    Text("Hide rooms")
                                        .foregroundColor(.gray)
                                        .fontWeight(.light)
                                } else {
                                    Text("Show rooms")
                                        .foregroundColor(.gray)
                                        .fontWeight(.light)
                                }
                            }
                            
                            
                            if let rooms = showRoomsForGroup, showRoomsForGroup == result.studyRoomResult.rooms {
                                ForEach(rooms) { room in
                                    StudyRoomCell(room: room)
                                        .tint(.black)
                                }
                            }
                        }
                    }
                }.padding()
            }
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
