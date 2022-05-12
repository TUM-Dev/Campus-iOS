//
//  LecturesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LecturesView: View {
    var model: Model
    var lecturesBySemester: [(String, [Lecture])]
    
    var body: some View {
        List {
            ForEach(lecturesBySemester, id: \.0) { lecturesBySemester in
                Section(
                    header: GroupBoxLabelView(
                        iconName: "graduationcap.fill",
                        text: lecturesBySemester.0
                    )
                ) {
                    ForEach(lecturesBySemester.1) { item in
                        VStack {
                            NavigationLink(
                                destination:
                                    LectureDetailsScreen(model: self.model, lecture: item)
                                        .navigationBarTitleDisplayMode(.inline)
                            ) {
                                LectureView(lecture: item)
                            }

                            if item.id != lecturesBySemester.1.last?.id {
                                Divider()
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
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView(
            model: MockModel(), lecturesBySemester: []
        )
    }
}
