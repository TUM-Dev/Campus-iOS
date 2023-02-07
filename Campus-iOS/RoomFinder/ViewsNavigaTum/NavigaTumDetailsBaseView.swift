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
                        $0.name == "Roomcode" || $0.name == "Gebäudekennung"
                    }?.text ?? "No room code found!"
                )
           
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "building.columns",
                    text: chosenRoom.additionalProperties.properties.first {$0.name == "Architect's name" || $0.name == "Gebäudekennung"
                    }?.text ?? "No architect's name found!"
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "location.fill",
                    text: chosenRoom.additionalProperties.properties.first {
                        $0.name == "Address" || $0.name == "Adresse"
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
    static var previews: some View {
        NavigaTumDetailsBaseView(chosenRoom: NavigaTumDetailsView_Previews.chosenRoom)
    }
}

