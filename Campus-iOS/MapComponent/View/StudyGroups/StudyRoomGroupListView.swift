//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.06.23.
//

import SwiftUI

struct StudyRoomGroupListView: View {
    
    @StateObject var vmAnno: AnnotatedMapViewModel
    @StateObject var vm: MapViewModel //old should be replaced
    
    var body: some View {
        if !vmAnno.studyRoomGroups.isEmpty {
            Group {
                Label("Study Rooms", systemImage: "studentdesk").titleStyle()
                                    .padding(.top, 20)
                
                VStack {
                    ForEach(vmAnno.studyRoomGroups) { studyRoom in
                        NavigationLink(destination: StudyRoomGroupView(
                            vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                            selectedGroup: studyRoom,
                            rooms: vm.studyRoomsResponse.rooms ?? [],
                            canDismiss: false
                        )) {
                            if let rooms =  studyRoom.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? []){
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "pencil.circle")
                                            .resizable()
                                            .foregroundColor(Color.highlightText)
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                        Text(studyRoom.name!)
                                            .foregroundColor(Color.primaryText)
                                            .multilineTextAlignment(.leading)
                                        let freeRooms = rooms.filter{ $0.isAvailable() }.count
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
                                    if studyRoom != vmAnno.studyRoomGroups.last {
                                        Divider()
                                    }
                                }
                                
                            } else { //not nice
                                EmptyView()
                            }
                        }
                    }
                }
                .sectionStyle()
            }
        }
    }
}
