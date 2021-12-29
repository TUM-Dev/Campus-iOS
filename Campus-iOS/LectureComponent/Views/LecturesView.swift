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
                        iconName: "graduationcap.fill",
						text: lecturesBySemester.1[0].semester 
                    )
                ) {
					ForEach(lecturesBySemester.1) { item in
						VStack {
							NavigationLink(
								destination:
									LectureDetailsScreen(lecture: item)
										.navigationBarTitleDisplayMode(.inline)
							) {
								LectureView(lecture: item)
							}

							if item.id != lecturesBySemester.1[lecturesBySemester.1.count - 1].id {
								Divider()
							}
						}
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
            lecturesBySemester: []
        )
    }
}
