//
//  Cafeteria+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

extension Cafeteria {
    static let previewData = [
        Cafeteria(location: Location(latitude: 48.147420, longitude: 11.567220, address: "Arcisstraße 17, München"), name: "Mensa Arcisstraße", id: "mensa-arcisstr", queueStatusApi: nil, queue: nil),
        Cafeteria(location: Location(latitude: 0.0, longitude: 0.0, address: "xystraße, München"), name: "Mensa XY", id: "mensa-xy", queueStatusApi: nil, queue: nil),
        // Mensa Garching has an maximum capacity of 1500 people (calculated reversed with the current and percentage of a day, e.g. current = 2 and percent: 0.13333334 then 0.13333334/100 * x = 2 => 2/(13333334/100) = 1500)
        Cafeteria(location: Location(latitude: 48.268132, longitude: 11.672263, address: "Boltzmannstraße 19, Garching"), name: "Mensa Garching", id: "mensa-garching", queueStatusApi: Optional("https://mensa.liste.party/api/"), queue: Queue(current: 150, percent: 0.1))
    ]
}
