//
//  TESTStudyRoomsView.swift
//  Campus-iOS
//
//  Created by David Lin on 21.11.22.
//

import SwiftUI

struct TESTStudyRoomsView: View {
    @StateObject var vm: MapViewModel
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            Button("Load rooms and groups") {
                Task {
                    await vm.getRoomsAndGroups()
                }
            }
            Text("StudyRoomGroups")
            List(vm.studyRoomGroups) { studyRoomGroup in
                VStack {
                    Text(studyRoomGroup.name ?? "Group name missing")
                    Text(String(studyRoomGroup.rooms?.count ?? 0))
                }
            }
            
            Text("StudyRooms")
            List(vm.studyRooms) { studyRoom in
                VStack {
                    Text(studyRoom.name ?? "Room name missing")
                    if let attributes = studyRoom.attributes {
                        if attributes.count > 0 {
                            Text(String(attributes[0].name ?? "Attribute name missing"))
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
}

