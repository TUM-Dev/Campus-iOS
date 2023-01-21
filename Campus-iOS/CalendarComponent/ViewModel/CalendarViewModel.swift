//
//  CalendarViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import Foundation
import XMLCoder

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var state: APIState<[CalendarEvent]> = .na
    @Published var hasError: Bool = false
    
    let model: Model
    let service: CalendarService
    
    init(model: Model, service: CalendarService) {
        self.model = model
        self.service = service
    }
    
    func getCalendar(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        guard let token = self.model.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }

        do {
            let events = try await service.fetch(token: token, forcedRefresh: forcedRefresh)
            
            self.state = .success(
                data: events.filter( { $0.status != "CANCEL" } ).sorted {$0.startDate ?? .distantPast > $1.startDate ?? .distantPast})
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    var eventsByDate: [Date? : [CalendarEvent]] {
        if case .success(let data) = state {
            let sortedEvents = data.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
            let filteredEvents = sortedEvents.filter { Date() <= $0.startDate ?? Date() }
            let dictionary = Dictionary(grouping: filteredEvents, by: { $0.startDate?.removeTimeStamp })
            
            return dictionary
        
        } else {
            return [:]
        }
    }
    
    /*Deprecated*/
    
//    typealias ImporterType = Importer<CalendarEvent, CalendarAPIResponse, XMLDecoder>
//    private static let endpoint = TUMOnlineAPI.calendar
//    @Published var events: [CalendarEvent] = []
//    init(model: Model) {
//        self.model = model
//        self.service = CalendarService()
//        self.fetch()
//    }
//    
//    func fetch(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
//        if(self.model.isUserAuthenticated) {
//            let importer = ImporterType(endpoint: Self.endpoint, predicate: nil, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
//            DispatchQueue.main.async {
//                importer.performFetch(handler: { result in
//                    switch result {
//                    case .success(let storage):
//                        self.events = storage.events.filter( { $0.status != "CANCEL" } ).sorted(by: {
//                            guard let dateOne = $0.startDate, let dateTwo = $1.startDate else {
//                                return false
//                            }
//                            return dateOne > dateTwo
//                        })
//                        
//                        callback(.success(true))
//                    case .failure(let error):
//                        self.state = .failed(error: error)
//                    }
//                })
//            }
//            
//        } else {
//            self.events = []
//        }
//    }
//    
//    var eventsByDate: [Date? : [CalendarEvent]] {
//        let sortedEvents = events.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
//        let filteredEvents = sortedEvents.filter { Date() <= $0.startDate ?? Date() }
//        let dictionary = Dictionary(grouping: filteredEvents, by: { $0.startDate?.removeTimeStamp })
//        return dictionary
//    }
    /*Deprecated*/
}

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
