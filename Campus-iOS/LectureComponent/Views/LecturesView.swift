//
//  LecturesView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LecturesView: View {
    @State private var searchQuery: String = ""
    var model: Model
    var lecturesBySemester: [(String, [Lecture])]
    
    private var lecturesBySemesterSearchResult: [(String, [Lecture])] {
        guard !self.searchQuery.isEmpty else {
            return self.lecturesBySemester
        }
        
        return self.lecturesBySemester.compactMap { tupel in
            let matchingLectures = tupel.1.filter { lecture in
                lecture.title.lowercased().contains(self.searchQuery.lowercased()) || lecture.speaker.lowercased().contains(self.searchQuery.lowercased())
            }
            
            return (!matchingLectures.isEmpty) ? (tupel.0, matchingLectures) : nil
        }
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            List {
                ForEach(lecturesBySemesterSearchResult, id: \.0) { lecturesBySemester in
                    Section(header: Text(lecturesBySemester.0)
                        .font(.headline.bold())
                        .foregroundColor(Color("tumBlue"))
                        .accessibilityHeading(.h2)
                    ) {
                        ForEach(lecturesBySemester.1) { item in
                            VStack {
                                NavigationLink(
                                    destination:
                                        LectureDetailsScreen(model: self.model, lecture: item)
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
                .listRowBackground(Color.secondaryBackground)
            }
            .listRowSeparator(.hidden)
            .background(Color.primaryBackground)
            .scrollContentBackground(.hidden)
        } else {
            Text("Only available on iOS 16 or higher 😔")
        }
    }
}

struct LecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesView(
            model: MockModel(), lecturesBySemester: []
        )
    }
}
