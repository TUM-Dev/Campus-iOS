//
//  MovieDetailsBasicInfoView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 23.06.22.
//
//
import SwiftUI

struct MovieDetailsBasicInfoView: View {

    var movieDetails: Movie

    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Basic Information".localized
            )
            .padding(.bottom, 10)
        ) {
            // TODO: Ideally we set always present values as not optional
            VStack(alignment: .leading, spacing: 8) {
                MovieDetailsBasicInfoRowView(
                    iconName: "hourglass",
                    text: movieDetails.title ?? ""
                )
                Divider()
                MovieDetailsBasicInfoRowView(
                    iconName: "book.fill",
                    text: movieDetails.genre ?? ""
                )
                Divider()
//                MovieDetailsBasicInfoRowView(
//                    // TODO: add film clapboard logo for director
//                    iconName: "person.fill",
//                    text: movieDetails.director ?? ""
//                )
//                Divider()
//                MovieDetailsBasicInfoRowView(
//                    iconName: "hourglass",
//                    text: movieDetails.runtime ?? ""
//                )
//                Divider()
                
                // TODO: Any way to access location?
                MovieDetailsBasicInfoRowView(
                    iconName: "map.fill",
                    text: "location" //?? ""
                )

                if let unwrappedDate = movieDetails.date {
                    Divider()
                    MovieDetailsBasicInfoRowView(
                        iconName: "clock.fill",
                        text: DateFormatter().string(from: unwrappedDate)
                    )
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct MovieDetailsBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsBasicInfoView(movieDetails: Movie.dummyData)
    }
}

