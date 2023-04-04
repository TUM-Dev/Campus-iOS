//
//  NavigaTumMapView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 10.01.23.
//
import SwiftUI
import MapKit

struct NavigaTumMapView: View {
    @State var chosenRoom: NavigaTumNavigationDetails

    var body: some View {
        GroupBox(
            label:  HStack {
                GroupBoxLabelView(
                    iconName: "map.fill",
                    text: "Building".localized
                )
                .padding(.bottom, 10)
                Spacer()
//                Button("Open in Maps") {
//                    // TODO: Update Info.plist to allow maps?
//                    let url = URL(string: "maps://?saddr&daddr=\(chosenRoom.coordinates.latitude), \(chosenRoom.coordinates.longitude)")
//                    if UIApplication.shared.canOpenURL(url!) {
//                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                    }
//                }
//                .font(.footnote)
            }
        ) {
            let coords = CLLocationCoordinate2D(latitude: chosenRoom.coordinates.latitude, longitude: chosenRoom.coordinates.longitude)
            let mapRegion = MKCoordinateRegion(center: coords , span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            Map(coordinateRegion: .constant(mapRegion), showsUserLocation: true, annotationItems: [RoomFinderLocation(coordinate: coords)]) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .frame(height: 360)
            .cornerRadius(10)
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct NavigaTumMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigaTumMapView(chosenRoom: NavigaTumDetailsView_Previews.chosenRoom)
    }
}
