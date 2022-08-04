//
//  MovieDetailsDetailedInfoView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 29.06.22.
//

import SwiftUI

struct MovieDetailsDetailedInfoView: View {
    var movieDetails: Movie
    
    var body: some View {
        GroupBox (
            label: GroupBoxLabelView(
                iconName: "tray.fill",
                // TODO: ADD localized names for this and in MovieDetailsBasicInfoView
                text: "Detailed Movie Information".localized
            )
            .padding(.bottom, 5)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                // Display Directors, Actors and Description
                
                if let director = movieDetails.director, !director.isEmpty {
                    MovieDetailsDetailedInfoRowView(
                        // TODO: Localized names
                        title: "Director".localized,
                        text: director
                    )
                    Divider()
                }
                
                if let actors = movieDetails.actors, !actors.isEmpty {
                    MovieDetailsDetailedInfoRowView(
                        // TODO: Localized names
                        title: "Actors".localized,
                        text: actors
                    )
                    Divider()
                }
                
                if let runtime = movieDetails.runtime, !runtime.isEmpty {
                    MovieDetailsDetailedInfoRowView(
                        // TODO: Localized names
                        title: "Runtime".localized,
                        text: runtime
                    )
                    Divider()
                }
                
                if let movieDescription = movieDetails.movieDescription, !movieDescription.isEmpty {
                    MovieDetailsDetailedInfoRowView(
                        // TODO: Localized names
                        title: "Movie Description".localized,
                        text: movieDescription
                    )
                    Divider()
                }
                
                if let url = movieDetails.link {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Website URL".localized)
                            .font(.system(size: 16, weight: .semibold))
                        Link("More Information".localized, destination: url)
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                    }
                }
            }
//                    if (lectureDetails.courseObjective != nil && !lectureDetails.courseObjective!.isEmpty) || (lectureDetails.note != nil && !lectureDetails.note!.isEmpty) {
//                        Divider()
//                    }

//                if let courseObjective = lectureDetails.courseObjective, !courseObjective.isEmpty {
//                    LectureDetailsDetailedInfoRowView(
//                        title: "Course Objective".localized,
//                        text: courseObjective
//                    )
//
//                    if (lectureDetails.note != nil && !lectureDetails.note!.isEmpty) {
//                        Divider()
//                    }
//                }
//                if let note = lectureDetails.note, !note.isEmpty {
//                    LectureDetailsDetailedInfoRowView(
//                        title: "Note".localized,
//                        text: note
//                    )
//                }
//            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct MovieDetailsDetailedInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsDetailedInfoView(lectureDetails: LectureDetails.dummyData)
    }
}
