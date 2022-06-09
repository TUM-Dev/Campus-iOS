//
//  RoomFinderDetailsBase.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import SwiftUI

struct RoomFinderDetailsBaseView: View {
    
    @State var room: FoundRoom
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Room Details".localized
            )
            .padding(.bottom, 10)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                LectureDetailsBasicInfoRowView(
                    iconName: "qrcode.viewfinder",
                    text: room.roomCode
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "building.columns",
                    text: "\(room.campus), \(room.buildingNumber)"
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "location.fill",
                    text: room.address
                )
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct RoomFinderDetailsBase_Previews: PreviewProvider {
    
    static var foundRoom = FoundRoom(roomId: "1", roomCode: "code123", buildingNumber: "building123", id: "someOtherID", info: "Info regarding the room", address: "Strasse 5", purpose: "Some meaningless room", campus: "Campus name", name: "Room Name")
    
    static var previews: some View {
        RoomFinderDetailsBaseView(room: foundRoom)
    }
}
