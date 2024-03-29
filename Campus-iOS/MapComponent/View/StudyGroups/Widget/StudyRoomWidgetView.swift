//
//  StudyRoomWidgetView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.02.23.
//

import SwiftUI

struct StudyRoomWidgetView: View {
    
    @StateObject var studyRoomWidgetVM : StudyRoomWidgetViewModel
    
    var body: some View {
        VStack (spacing: 0) {
            Text("Nearest Study Room").titleStyle()
            NavigationLink(destination: StudyRoomGroupView(
                vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                selectedGroup: studyRoomWidgetVM.studyGroup,
                rooms: studyRoomWidgetVM.rooms ?? [],
                canDismiss: false
            )) {
                if let studyGroup = self.studyRoomWidgetVM.studyGroup,
                   let rooms = studyRoomWidgetVM.rooms {
                    Label {
                        HStack {
                            Text(studyGroup.name!).foregroundColor(Color.primaryText)
                            let freeRooms = rooms.filter{ $0.isAvailable() }.count
                            if freeRooms > 0 {
                                Spacer()
                                Text("\(freeRooms) "+"rooms free").foregroundColor(.green)
                            } else {
                                Spacer()
                                Text("No rooms free").foregroundColor(.red)
                            }
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "pencil.circle").foregroundColor(Color.highlightText)
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
}
