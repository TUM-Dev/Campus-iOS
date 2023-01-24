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
                Button("Open in Maps") {
                    // TODO: Update Info.plist to allow maps?
                    let url = URL(string: "maps://?saddr&daddr=\(chosenRoom.coordinates.latitude), \(chosenRoom.coordinates.longitude)")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }
                .font(.footnote)
            }
        ) {
            let coords = CLLocationCoordinate2D(latitude: chosenRoom.coordinates.latitude, longitude: chosenRoom.coordinates.longitude)
            let mapRegion = MKCoordinateRegion(center: coords , span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            Map(coordinateRegion: .constant(mapRegion), showsUserLocation: true, annotationItems: [RoomFinderLocation(coordinate: coords)]) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .frame(height: 180)
            .cornerRadius(10)
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct NavigaTumMapView_Previews: PreviewProvider {
    static let props = [NavigaTumNavigationProperty(name: "Roomcode", text: "5606.EG.036"), NavigaTumNavigationProperty(name: "Architect's name", text: "00.06.036"), NavigaTumNavigationProperty(name: "Address", text: "Boltzmannstr. 3, EG, 85748 Garching b. München")]
    static let additionalProperties = NavigaTumNavigationAdditionalProperties(properties: props)
    static let coords = NavigaTumNavigationCoordinates(latitude: 48.26217845031176, longitude: 11.668693278105701)
    static let available = [NavigaTumRoomFinderMap(id: "rf95", name: "FMI Garching BT06 EG", imageUrl: "rf95.webp", height: 605, width: 318, x: 207, y: 217, scale: "500"),
                            NavigaTumRoomFinderMap(id: "rf142", name: "FMI Übersicht", imageUrl: "rf142.webp", height: 461, width: 639, x: 443, y: 242, scale: "2000"),
                            NavigaTumRoomFinderMap(id: "rf80", name: "Lageplan Campus Garching", imageUrl: "rf80.webp", height: 480, width: 676, x: 329, y: 344, scale: "10000"),
                            NavigaTumRoomFinderMap(id: "rf54", name: "München", imageUrl: "rf54.webp", height: 603, width: 640, x: 444, y: 36, scale: "200000"),
                            NavigaTumRoomFinderMap(id: "rf156", name: "München und Umgebung", imageUrl: "rf156.webp", height: 515, width: 420, x: 265, y: 167, scale: "400000")]
    static let maps = NavigaTumNavigationMaps(default: "rf95", roomfinder: NavigaTumRoomFinderMaps(available: available , defaultMapId: "rf95"))
    static var chosenRoom = NavigaTumNavigationDetails(id: "5606.EG.036", name: "5606.EG.036 (MPI Fachschaftsbüro im MI)", parentNames: ["Standorte", "Garching Forschungszentrum","Fakultät Mathematik & Informatik (FMI oder MI)", "Finger 06 (BT06)"], type: "room", typeCommonName: "Office", additionalProperties: additionalProperties, coordinates: coords, maps: maps)
    static var previews: some View {
        NavigaTumMapView(chosenRoom: chosenRoom)
    }
}

