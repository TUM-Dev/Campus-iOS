//
//  GradesSemesterView.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 23.05.23.
//

import SwiftUI

struct GradesSemesterView: View {
    let semesterName: String
    let grades: [Grade]
    
    var body: some View {
        Section(header: Text(semesterName)
            .font(.headline.bold())
            .foregroundColor(Color("tumBlue"))
            .accessibilityHeading(.h2)
        ) {
            ForEach(grades) { item in
                VStack {
                    GradeView(grade: item)
                    
                    if let id = grades.last?.id {
                        if item.id != id {
                            Divider()
                        }
                    }
                }
            }
            .listRowInsets(
                EdgeInsets(
                    top: 4,
                    leading: 18,
                    bottom: 2,
                    trailing: 18
                )
            )
        }
    }
}

