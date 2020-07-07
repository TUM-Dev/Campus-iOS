//
//  MovieDetailViewModel.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

struct MovieDetailViewModel: Hashable {
    let sections: [Section]

    struct Section: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let cells: [AnyHashable]
    }

    struct Header: Identifiable, Hashable {
        let id = UUID()
        let imageURL: URL?
        let title: String?
    }

    struct Cell: Identifiable, Hashable {
        let id = UUID()
        let key: String
        let value: String
    }

    struct LinkCell: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let link: URL
    }

    init(movie: Movie) {
        let header = Header(imageURL: movie.cover, title: movie.title)

        var general: [Cell] = []
        if let actors = movie.actors {
            general.append(Cell(key: "Actors".localized, value: actors))
        }

        if let date = movie.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            general.append(Cell(key: "Date".localized, value: dateFormatter.string(from: date)))
        }

        if let director = movie.director {
            general.append(Cell(key: "Director".localized, value: director))
        }

        if let genre = movie.genre {
            general.append(Cell(key: "Genre".localized, value: genre))
        }

        if let runtime = movie.runtime {
            general.append(Cell(key: "Runtime".localized, value: runtime))
        }

        if let rating = movie.rating {
            general.append(Cell(key: "Rating".localized, value: rating))
        }

        if let year = movie.year {
            general.append(Cell(key: "Year".localized, value: year))
        }

        var movieDescription: [Cell] = []
        if let description = movie.movieDescription {
            movieDescription.append(Cell(key: "Description".localized, value: description))
        }

        var links: [LinkCell] = []
        if let link = movie.link {
            links.append(LinkCell(name: "TU Film Homepage", link: link))
        }

        self.sections = [
            Section(name: "Header", cells: [header]),
            Section(name: "General", cells: general),
            Section(name: "Description", cells: movieDescription),
            Section(name: "Links", cells: links)
            ].filter { !$0.cells.isEmpty }
    }

}
