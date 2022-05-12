//
//  LectureDetailsDetailedInfoView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsDetailedInfoView: View {
    var lectureDetails: LectureDetails
    
    var body: some View {
        GroupBox (
            label: GroupBoxLabelView(
                iconName: "tray.fill",
                text: "Detailed lecture information".localized
            )
            .padding(.bottom, 5)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                if let courseContents = lectureDetails.courseContents, !courseContents.isEmpty {
                    LectureDetailsDetailedInfoRowView(
                        title: "Course Contents".localized,
                        text: courseContents
                    )
                    
                    if (lectureDetails.courseObjective != nil && !lectureDetails.courseObjective!.isEmpty) || (lectureDetails.note != nil && !lectureDetails.note!.isEmpty) {
                        Divider()
                    }
                }
                if let courseObjective = lectureDetails.courseObjective, !courseObjective.isEmpty {
                    LectureDetailsDetailedInfoRowView(
                        title: "Course Objective".localized,
                        text: courseObjective
                    )
                    
                    if (lectureDetails.note != nil && !lectureDetails.note!.isEmpty) {
                        Divider()
                    }
                }
                if let note = lectureDetails.note, !note.isEmpty {
                    LectureDetailsDetailedInfoRowView(
                        title: "Note".localized,
                        text: note
                    )
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct LectureDetailsDetailedInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsDetailedInfoView(lectureDetails: LectureDetails.dummyData)
    }
}
