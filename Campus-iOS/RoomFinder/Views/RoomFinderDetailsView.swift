//
//  RoomFinderDetailsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import SwiftUI

struct RoomFinderDetailsView: View {
    
    @State var room: FoundRoom
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(room.info)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Text(room.purpose)
                    .font(.subheadline)
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RoomFinderDetailsBaseView(room: room)
                    RoomFinderDetailsMapView(room: room)
                    RoomFinderDetailsMapImagesView(room: room)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .padding(.horizontal)
    }
}

struct RoomFinderDetailsView_Previews: PreviewProvider {
    
    static var foundRoom = FoundRoom(roomId: "1", roomCode: "code123", buildingNumber: "building123", id: "someOtherID", info: "Info regarding the room", address: "Strasse 5", purpose: "Some meaningless room", campus: "Campus name", name: "Room Name")
    
    static var previews: some View {
        RoomFinderDetailsView(room: foundRoom)
    }
}
