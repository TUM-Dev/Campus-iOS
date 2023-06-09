//
//  RoomDetailsView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.06.23.
//

import SwiftUI

struct RoomDetailsView: View {
    
    let room: NavigaTumNavigationEntity
    let details: NavigaTumNavigationDetails
    
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Room Details".localized
            )
            .padding(.bottom, 10)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(details.additionalProperties.properties, id: \.name) { property in
                    LectureDetailsBasicInfoRowView(iconName: iconName(property.name), text: property.text)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
    
    func iconName(_ name: String) -> String {
        if name == "Roomcode" || name == "Raumkennung" {
            return "qrcode.viewfinder"
        } else if name == "Architect's name" || name == "Architekten-Name" || name == "Gebäudekennung" || name == "Buildingcode" {
            return "building.columns"
        } else if name == "Address" || name == "Adresse" {
            return "location.fill"
        } else if name == "Stockwerk" || name == "Floor" {
            return "figure.stairs"
        } else if name == "Sitzplätze" || name == "Seats" {
            return "person.2.fill"
        } else if name == "Anzahl Räume" || name == "Number of rooms"{
            return "door.right.hand.closed"
        } else if name == "Anzahl Gebäude" || name == "Number of buildings" {
            return "building.2"
        } else {
            return "questionmark.circle"
        }
    }
}
