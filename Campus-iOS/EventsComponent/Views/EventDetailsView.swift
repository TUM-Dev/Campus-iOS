//
//  EventDetailsView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 08.06.23.
//

import SwiftUI

struct EventDetailsView: View {
    var event: TUMEvent
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Event Details".localized
            )
            .padding(.bottom, 10)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                LectureDetailsBasicInfoRowView(
                    iconName: "qrcode.viewfinder",
                    text: event.title
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "person.fill",
                    text: event.user
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "link",
                    text: event.link
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "doc.plaintext",
                    text: event.body
                )
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: EventElementView_Previews.event)
    }
}
