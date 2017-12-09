//
//  DetailedStation.swift
//  Campus
//
//  Created by Mathias Quintero on 10/23/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

let departureTimeSlackInterval = 60.0

protocol DetailedStationDelegate: AnyObject {
    func station(_ station: DetailedStation, didUpdate departures: [Departure])
}

class DetailedStation {
    
    let station: Station
    private(set) var allDepartures: [Departure]
    
    private var requestTimer: Timer?
    private var updateTimer: Timer?
    private let mvgManager: MVGManager
    
    weak var delegate: DetailedStationDelegate?
    
    var relevantDepartures: [Departure] {
        let departuresInTimeRange = allDepartures |> { $0.departureTime.timeIntervalSinceNow > -departureTimeSlackInterval }
        return departuresInTimeRange.array(withFirst: 5)
    }
    
    init(station: Station, mvgManager: MVGManager) {
        self.station = station
        self.mvgManager = mvgManager
        allDepartures = []
        scheduleRequest()
    }
    
    deinit {
        updateTimer?.invalidate()
        requestTimer?.invalidate()
    }
    
    private func updateDelegate() {
        scheduleUpdate()
        DispatchQueue.main >>> {
            self.delegate?.station(self, didUpdate: self.relevantDepartures)
        }
    }
    
    private func refresh(laterThan date: Date?) {
        mvgManager.fetch(for: station).onSuccess { departures in
            let departures = date.map { date in departures |> { $0.departureTime > date } } ?? departures
            self.allDepartures.append(contentsOf: departures)
            self.updateDelegate()
            self.scheduleRequest()
        }
    }
    
    private func scheduleUpdate() {
        updateTimer?.invalidate()
        guard let nextUpdate = relevantDepartures.first?.departureTime else { return }
        DispatchQueue.main >>> {
            let interval = nextUpdate.addingTimeInterval(departureTimeSlackInterval + 1.0).timeIntervalSinceNow
            self.updateTimer = Timer.scheduledTimer(withTimeInterval: interval,
                                                    repeats: false) { [unowned self] _ in
                                                        
                self.updateDelegate()
            }
        }
    }
    
    private func scheduleRequest() {
        requestTimer?.invalidate()
        guard let date = allDepartures.array(withLast: 5).first?.departureTime else {
            return refresh(laterThan: nil)
        }
        let interval = date.addingTimeInterval(-departureTimeSlackInterval).timeIntervalSinceNow
        DispatchQueue.main >>> {
            self.requestTimer = Timer.scheduledTimer(withTimeInterval: interval,
                                                     repeats: false) { [unowned self] _ in
                                                        
                self.refresh(laterThan: date)
            }
        }
    }
}

extension DetailedStation: DataElement {
    
    var text: String {
        return station.name
    }
    
    func getCellIdentifier() -> String {
        return "station"
    }
    
    var detailElements: [DataElement] {
        return relevantDepartures
    }
    
}
