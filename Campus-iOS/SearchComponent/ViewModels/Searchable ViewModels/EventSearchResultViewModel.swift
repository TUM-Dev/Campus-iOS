//
//  CalendarLectureSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 28.12.22.
//

import SwiftUI

struct EventSearchResult: Searchable {
    var comparisonTokens: [ComparisonToken] {
        return lecture.comparisonTokens + events.flatMap {$0.comparisonTokens}
    }
    
    let lecture: Lecture
    let events: [CalendarEvent]
}

@MainActor
class EventSearchResultViewModel: ObservableObject {
    @Published var results = [(event: EventSearchResult, distance: Distances)]()
    private let lecturesService = LecturesService()
    private let calendarService = CalendarService()
    private let model: Model
    
    var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    init(model: Model) {
        self.model = model
    }
    
    func eventsSearch(for query: String) async {
        guard let lectures = await fetchLectures() else {
            return
        }
        
        var eventResults = [EventSearchResult]()
        if let calendar = await fetchCalendarEvents() {
            eventResults = lectures.map { lecture in
                let lectureEvents = calendar.filter { currentCalendarEvent in
                    if let nr = currentCalendarEvent.lvNr {
                        return nr == String(lecture.id)
                    }
                    return false
                }
                
                return EventSearchResult(lecture: lecture, events: lectureEvents)
            }
        } else {
            // If e.g. we do not have the permisson to read calendar, but lectures
            eventResults = lectures.map { EventSearchResult(lecture: $0, events: []) }
        }
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: eventResults) {
            self.results = optionalResults
        }
    }
    
    func fetchLectures() async -> [Lecture]? {
        //TODO: Error handling instead of returning nil when an error is thrown
        guard let token = self.token else {
            return nil
        }
        
        do {
            return try await lecturesService.fetch(token: token)
        } catch {
            print("No lectures were fetched")
            return nil
        }
    }
        
    func fetchCalendarEvents() async -> [CalendarEvent]? {
        guard let token = self.token else {
            return nil
        }
        
        do {
            return try await calendarService.fetch(token: token, forcedRefresh: false)
        } catch {
            print("No calendar events were fetched: \(error)")
            return nil
        }
    }
}
