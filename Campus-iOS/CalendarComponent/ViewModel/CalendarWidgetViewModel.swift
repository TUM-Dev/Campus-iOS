//
//  CalendarWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 02.11.22.
//

import Foundation

@MainActor
class CalendarWidgetViewModel: ObservableObject {
    
    @Published var events: [CalendarEvent]?
    private let model: Model
    private let calendarVm: CalendarViewModel
    
    init() {
        self.events = nil
        self.model = Model()
        self.calendarVm = CalendarViewModel(model: model)
    }
    
    var eventsByDate: [Date? : [CalendarEvent]] {
        guard let events else {
            return [:]
        }
        let sortedEvents = events.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
        let dictionary = Dictionary(grouping: sortedEvents, by: { $0.startDate?.removeTimeStamp })
        return dictionary
    }

    var upcomingEvents: [CalendarEvent] {
        
        guard let events else {
            return []
        }
        
        let now = Date()

        let futureEvents: [CalendarEvent] = events
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
    
    func fetch() async {
                
        // TODO: find a cleaner way to "await" the Alamofire request.
        while (!calendarVm.model.isUserAuthenticated) {
            try? await Task.sleep(nanoseconds: 1_000_000 * 100)
        }
        
        calendarVm.fetch()
        
        // TODO: find a cleaner way to "await" the Alamofire request.
        while (calendarVm.events == nil) {
            try? await Task.sleep(nanoseconds: 1_000_000 * 100)
        }
        
        self.events = calendarVm.events
    }
    
    func getModel() -> Model {
        return self.model
    }
}
