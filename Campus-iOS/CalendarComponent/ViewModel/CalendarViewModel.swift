//
//  CalendarViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import Foundation
import XMLCoder

class CalendarViewModel: ObservableObject {
    typealias ImporterType = Importer<CalendarEvent, CalendarAPIResponse, XMLDecoder>
    private static let endpoint = TUMOnlineAPI.calendar
    
    @Published var events: [CalendarEvent] = []
    
    let model: Model
    var state: State = .na
    
    init(model: Model) {
        self.model = model
        fetch()
    }
    
    
    func fetch(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
        if(self.model.isUserAuthenticated) {
            let importer = ImporterType(endpoint: Self.endpoint, predicate: nil, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
            DispatchQueue.main.async {
                importer.performFetch(handler: { result in
                    switch result {
                    case .success(let storage):
                        self.events = storage.events?.filter( { $0.status != "CANCEL" } ).sorted(by: {
                            guard let dateOne = $0.startDate, let dateTwo = $1.startDate else {
                                return false
                            }
                            return dateOne > dateTwo
                        }) ?? []
                        
                        if let _ = storage.events {
                            callback(.success(true))
                        } else {
                            callback(.failure(CampusOnlineAPI.Error.noPermission))
                        }
                    case .failure(let error):
                        self.state = .failed(error: error)
                    }
                })
            }
            
        } else {
            self.events = []
        }
    }
    
    var eventsByDate: [Date? : [CalendarEvent]] {
        let sortedEvents = events.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
        let dictionary = Dictionary(grouping: sortedEvents, by: { $0.startDate?.removeTimeStamp })
        return dictionary
    }

	var upcomingEvents: [CalendarEvent] {
        
        let now = Date()

        let futureEvents: [CalendarEvent] = self.events
            .compactMap { event in
                guard let _ = event.startDate, let endDate = event.endDate, now <= endDate else { return nil }
                return event
            }
                
        let groupedEvents: Dictionary<Date, [CalendarEvent]> = Dictionary(grouping: futureEvents) { event -> Date in
            let components = Calendar.current.dateComponents([.day, .month, .year], from: event.startDate!)
            let date = Calendar.current.date(from: components)!
            
            return date
        }

        let upcomingEvents = groupedEvents.min { $0.key < $1.key }?.value ?? []
        
        return upcomingEvents.sorted{ $0.startDate! < $1.startDate! }
    }
}

extension CalendarViewModel {
    enum State {
        case na
        case loading
        case success(data: [CalendarEvent]?)
        case failed(error: Error)
    }
}

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
