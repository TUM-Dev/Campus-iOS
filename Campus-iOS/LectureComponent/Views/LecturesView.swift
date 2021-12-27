//
//  LecturesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LecturesView: View {
    var lecturesBySemester: [(String, [Lecture])]
    
    var body: some View {
        List {
            ForEach(lecturesBySemester, id: \.0) { lecturesBySemester in
                Section(
                    header: GroupBoxLabelView(
                        iconName: "graduationcap",
                        text: lecturesBySemester.0
                    )
                ) {
                    ForEach(lecturesBySemester.1) { item in
                        NavigationLink(
                            destination:
                                LectureDetailsScreen(lecture: item)
                                    .navigationBarTitleDisplayMode(.inline)
                        ) {
                            LectureView(lecture: item)
                        }
                    }
                }
            }
        }
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView(
            lecturesBySemester: []
        )
    }
}
