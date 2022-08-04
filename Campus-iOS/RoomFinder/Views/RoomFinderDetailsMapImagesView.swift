//
//  RoomFinderDetailsMapImagesView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.06.22.
//

import SwiftUI

struct RoomFinderDetailsMapImagesView: View {
    
    @State var room: FoundRoom
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "photo.fill.on.rectangle.fill",
                text: "Room".localized
            )
            .padding(.bottom, 10)
        ) {
            
            Divider()

            MapImagesHorizontalScrollingView(viewModel: StudyRoomViewModel(studyRoom: StudyRoom(room: room)))
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
      )
    }
}

struct RoomFinderDetailsMapImagesView_Previews: PreviewProvider {
    
    static var foundRoom = FoundRoom(roomId: "1", roomCode: "code123", buildingNumber: "building123", id: "someOtherID", info: "Info regarding the room", address: "Strasse 5", purpose: "Some meaningless room", campus: "Campus name", name: "Room Name")
    
    static var previews: some View {
        RoomFinderDetailsMapImagesView(room: foundRoom)
    }
}
