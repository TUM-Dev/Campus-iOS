//
//  StudyRoomWidgetViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.02.23.
//

import SwiftUI

struct StudyRoomWidgetViewNEW: View {
    
    @StateObject var studyRoomWidgetVM : StudyRoomWidgetViewModel
    
    var body: some View {
        NavigationLink(destination: StudyRoomGroupView(
            vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
            selectedGroup: $studyRoomWidgetVM.studyGroup,
            rooms: studyRoomWidgetVM.rooms ?? [],
            canDismiss: false
        )) {
            if let studyGroup = self.studyRoomWidgetVM.studyGroup,
               let rooms = studyRoomWidgetVM.rooms {
                Label {
                    HStack {
                        Text(studyGroup.name!).foregroundColor(Color.primaryText)
                        if let freeRooms = rooms.filter{ $0.isAvailable() }.count,
                        freeRooms > 0 {
                            Spacer()
                            Text("\(freeRooms) rooms free").foregroundColor(.green)
                        } else {
                            Spacer()
                            Text("No rooms free").foregroundColor(.red)
                        }
                        Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                    }
                } icon: {
                    Image(systemName: "book").foregroundColor(Color.primaryText)
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
            } else {
                
            }
        }
        .frame(width: Size.cardWidth)
        .background(Color.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}
