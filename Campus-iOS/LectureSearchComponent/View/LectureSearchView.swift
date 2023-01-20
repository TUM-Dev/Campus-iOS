//
//  LectureSearchListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct LectureSearchView: View {
    @Environment(\.isSearching) private var isSearching
    
    let model: Model
    let lectures: [Lecture]
    
    var body: some View {
        List {
            ForEach(lectures) { lecture in
                NavigationLink(
                    destination: LectureDetailsScreen(model: self.model, lecture: lecture)
                                    .navigationBarTitleDisplayMode(.inline)
                ) {
                    HStack {
                        Text(lecture.title)
                        Spacer()
                        Text(lecture.eventType)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
        }
    }
}

struct LectureSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        LectureSearchView(model: Model(), lectures: [])
    }
}
