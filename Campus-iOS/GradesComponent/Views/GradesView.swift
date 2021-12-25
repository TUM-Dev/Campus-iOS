//
//  GradesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI

struct GradesView: View {
    var gradesBySemester: [(String, [Grade])]
    
    var body: some View {
        ForEach(gradesBySemester, id: \.0) { gradesBySemester in
            GroupBox(
                label: GroupBoxLabelView(semester: gradesBySemester.0)
            ) {
                ForEach(gradesBySemester.1) { item in
                    GradeView(grade: item)
                    
                    if item.id != gradesBySemester.1.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(gradesBySemester: [])
    }
}
