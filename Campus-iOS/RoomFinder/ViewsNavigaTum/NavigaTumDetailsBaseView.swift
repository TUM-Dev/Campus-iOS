//
//  NavigaTumDetailsBaseView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 10.01.23.
//

import SwiftUI

struct NavigaTumDetailsBaseView: View {
    @State var chosenRoom: NavigaTumNavigationDetails

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
                    text: chosenRoom.additionalProperties.properties.first {
                        $0.name == "Roomcode"
                    }?.text ?? "No room code found!"
                )
           
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "building.columns",
                    text: chosenRoom.additionalProperties.properties.first {$0.name == "Architect's name"
                    }?.text ?? "No architect's name found!"
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "location.fill",
                    text: chosenRoom.additionalProperties.properties.first {
                        $0.name == "Address"
                    }?.text ?? "No Address found!"
                )
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct NavigaTumDetailsBaseView_Previews: PreviewProvider {
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
        NavigaTumDetailsBaseView(chosenRoom: chosenRoom)
    }
}
