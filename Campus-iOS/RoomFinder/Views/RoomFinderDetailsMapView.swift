//
//  RoomFinderDetailsMapView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import SwiftUI
import MapKit

struct RoomFinderLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RoomFinderDetailsMapView: View {
    
    @ObservedObject var viewModel = RoomFinderMapViewModel()
    
    @State var room: FoundRoom
    @State var locationManager = CLLocationManager()
    
    var fixAddress: String {
        room.address.components(separatedBy: ",(")[0] + ", Munich, Germany"
    }
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "map.fill",
                text: "Building".localized
            )
            .padding(.bottom, 10)
        ) {
            
            Divider()
            
            if viewModel.errorConvertingAddress {
                HStack {
                    Spacer()
                    Text("Address cannot be determined!")
                        .bold()
                    Spacer()
                }
            } else if let locationR = viewModel.location {
                let mapRegion = MKCoordinateRegion(center: locationR, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                
                Map(coordinateRegion: .constant(mapRegion), showsUserLocation: true, annotationItems: [RoomFinderLocation(coordinate: locationR)]) { location in
                    MapMarker(coordinate: location.coordinate)
                }
                .frame(width: .infinity, height: 180)
                .cornerRadius(10.0)
            } else {
                ProgressView()
            }
            
//            LectureDetailsBasicInfoRowView(
//                iconName: "location.fill",
//                text: viewModel.location.debugDescription
//            )
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
        .task {
            viewModel.convertAddress(address: self.fixAddress)
        }
    }
}

struct RoomFinderDetailsMapView_Previews: PreviewProvider {
    
    static var foundRoom = FoundRoom(roomId: "1", roomCode: "code123", buildingNumber: "building123", id: "someOtherID", info: "Info regarding the room", address: "Strasse 5", purpose: "Some meaningless room", campus: "Campus name", name: "Room Name")
    
    static var previews: some View {
        RoomFinderDetailsMapView(room: foundRoom)
    }
}
