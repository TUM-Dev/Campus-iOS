//
//  LectureDetailsLinkView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsLinkView: View {
    var lectureDetails: LectureDetails
    @State var selectedLink: URL? = nil
    
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
                    Text("Curriculum").foregroundColor(.blue).onTapGesture {
                        self.selectedLink = curriculum
                    }
                    Divider()
                }
                if let dates = lectureDetails.scheduledDatesURL {
                    Text("Dates").foregroundColor(.blue).onTapGesture {
                        self.selectedLink = dates
                    }
                    Divider()
                }
                if let exam = lectureDetails.examDateURL {
                    Text("Exam").foregroundColor(.blue).onTapGesture {
                        self.selectedLink = exam
                    }
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
        .sheet(item: $selectedLink) { selectedLink in
            if let link = selectedLink {
                SFSafariViewWrapper(url: link)
            }
        }
    }
}

struct LectureDetailsLinkView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsLinkView(lectureDetails: LectureDetails.dummyData)
    }
}
