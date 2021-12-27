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
                label: GroupBoxLabelView(
                    iconName: "graduationcap",
                    text: lecturesBySemester.0
                )
            ) {
                ForEach(lecturesBySemester.1) { item in
                    NavigationLink(destination: LectureDetailsScreen(lecture: item)) {
                        HStack {
                            LectureView(lecture: item)
                            
                            Image(systemName: "chevron.right")
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 7)
                              .foregroundColor(.gray)
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .frame(alignment: .topLeading)
                    .buttonStyle(PlainButtonStyle())
                    
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
        LecturesView(
            lecturesBySemester: []
        )
    }
}
