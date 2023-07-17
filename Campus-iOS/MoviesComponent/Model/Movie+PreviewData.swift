//
//  Movie+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

extension Movie: Identifiable {
    static let dummyData: Movie = .init(
        id: 123,
        actors: "Morgan Freeman",
        cover: URL(string:"https://www.google.com"),
        created: Date.now,
        date: Date.now,
        director: "Frank Darapant",
        genre: "Crime",
        link: URL(string:"https://www.google.com"),
        movieDescription: "Yes",
        rating: "11/10",
        runtime: "194",
        title: "Shawshank Redemption",
        year: "2020"
    )
    
    static let previewData: [Movie] = [dummyData]
}
