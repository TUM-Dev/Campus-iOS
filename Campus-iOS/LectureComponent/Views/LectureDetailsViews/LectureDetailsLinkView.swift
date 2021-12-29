//
//  LectureDetailsLinkView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsLinkView: View {
    var lectureDetails: LectureDetails
    
    var body: some View {
        GroupBox (
            label: GroupBoxLabelView(
                iconName: "link.circle.fill",
                text: "Lecture links"
            )
            .padding(.bottom, 5)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                if let curriculum = lectureDetails.curriculumURL {
                    Link(destination: curriculum, label: {
                        Text("Curriculum")
                            .foregroundColor(.blue)
                    })
                    Divider()
                }
                if let dates = lectureDetails.scheduledDatesURL {
                    Link(destination: dates, label: {
                        Text("Dates")
                            .foregroundColor(.blue)
                    })
                    Divider()
                }
                if let exam = lectureDetails.examDateURL {
                    Link(destination: exam, label: {
                        Text("Exam")
                            .foregroundColor(.blue)
                    })
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct LectureDetailsLinkView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsLinkView(lectureDetails: LectureDetails.dummyData)
    }
}
