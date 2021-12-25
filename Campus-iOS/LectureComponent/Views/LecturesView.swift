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
        ForEach(lecturesBySemester, id: \.0) { lecturesBySemester in
            GroupBox(
                label: GroupBoxLabelView(semester: lecturesBySemester.0)
            ) {
                ForEach(lecturesBySemester.1) { item in
                    LectureView(lecture: item)
                    
                    if item.id != lecturesBySemester.1.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView(lecturesBySemester: [])
    }
}
