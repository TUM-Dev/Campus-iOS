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
    @Published var state: SearchState<EventSearchResult> = .na
    @Published var hasError: Bool = false
    let lecturesService: LecturesServiceProtocol
    let calendarService: CalendarServiceProtocol
    let model: Model
    
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
    
    init(model: Model, lecturesService: LecturesServiceProtocol, calendarService: CalendarServiceProtocol) {
        self.model = model
        self.lecturesService = lecturesService
        self.calendarService = calendarService
    }
    
    func eventsSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        guard let token = self.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        var calendarData = [CalendarEvent]()
        do {
            calendarData = try await calendarService.fetch(token: token, forcedRefresh: forcedRefresh)
            
        } catch {
            print("Error fetching Calendar: \(error)")
            // No error is thrown because we could have no permissons for the calendar, but for the lectures, i.e. only the lectures without calendar dates are shown
        }

        do {
            let lectureData = try await lecturesService.fetch(token: token, forcedRefresh: forcedRefresh)
            
            var eventResults = [EventSearchResult]()
            if calendarData.isEmpty {
                // If e.g. we do not have the permisson to read calendar, but lectures
                eventResults = lectureData.map { EventSearchResult(lecture: $0, events: []) }
            } else {
                eventResults = lectureData.map { lecture in
                    let lectureEvents = calendarData.filter { currentCalendarEvent in
                        if let nr = currentCalendarEvent.lvNr {
                            if let date = currentCalendarEvent.startDate, date >= Date() {
                                return nr == String(lecture.id)
                            } else {
                                return false
                            }
                        }
                        return false
                    }
                    
                    return EventSearchResult(lecture: lecture, events: lectureEvents)
                }
            }
            
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: eventResults) {
                self.state = .success(data: optionalResults)
            } else {
                self.state = .failed(error: SearchError.empty(searchQuery: query))
                self.hasError = true
            }
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
