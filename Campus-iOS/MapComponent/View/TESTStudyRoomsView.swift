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
                    await vm.getRoomsAndGrous()
                }
            }
            Text("StudyRoomGroups")
            List(vm.studyRoomGroups) { studyRoomGroup in
                Text(studyRoomGroup.name ?? "Group name missing")
            }
            
            Text("StudyRooms")
            List(vm.studyRooms) { studyRoom in
                Text(studyRoom.name ?? "Room name missing")
            }
            
        }
    }
}

