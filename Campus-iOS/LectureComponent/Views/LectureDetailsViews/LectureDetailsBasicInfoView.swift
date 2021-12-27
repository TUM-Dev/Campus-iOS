//
//  LectureDetailsBasicInfoView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsBasicInfoView: View {
    var lectureDetails: LectureDetails
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Basic lecture information"
            )
            .padding(.bottom, 5)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                LectureDetailsBasicInfoRowView(
                    iconName: "hourglass",
                    text: "\(lectureDetails.duration) SWS"
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "graduationcap",
                    text: lectureDetails.semester
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "book",
                    text: lectureDetails.organisation
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "person",
                    text: lectureDetails.speaker
                )
                if let firstMeeting = lectureDetails.firstScheduledDate {
                    Divider()
                    LectureDetailsBasicInfoRowView(
                        iconName: "clock",
                        text: firstMeeting
                    )
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
        .padding()
    }
}

struct LectureDetailsBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsBasicInfoView(lectureDetails: LectureDetails.dummyData)
    }
}
