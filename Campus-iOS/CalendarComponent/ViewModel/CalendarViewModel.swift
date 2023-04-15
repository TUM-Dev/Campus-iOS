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
    
    var eventsByDateNEW: [Date? : [CalendarEvent]] {
        if case .success(let data) = state {
            let sortedEvents = data.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
            let filteredEvents = sortedEvents.filter { Date() <= $0.startDate ?? Date() }
            let dictionary = Dictionary(grouping: filteredEvents, by: { $0.startDate })
            
            return dictionary
            
        } else {
            return [:]
        }
    }
    
    func getWidgetEventViews(events: [Dictionary<Date?, [CalendarEvent]>.Element]) -> ([CalendarWidgetEventView], [CalendarWidgetEventView]) {
        
        var leftColumn = [CalendarWidgetEventView]()
        var rightColumn = [CalendarWidgetEventView]()
        var rightColumnCounter = 0
        
        for entry in events {
            rightColumn.append(CalendarWidgetEventView(event: entry.value[0], title: entry.key!))
            for event in entry.value {
                if leftColumn.count == 0 && entry.key!.isToday {
                    leftColumn.append(CalendarWidgetEventView(event: event))
                }
                else if rightColumnCounter < 2 {
                    rightColumn.append(CalendarWidgetEventView(event: event))
                    rightColumnCounter += 1
                }
                else {
                    break
                }
            }
            if rightColumnCounter >= 2 {
                break
            }
        }
        return (leftColumn, rightColumn)
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
