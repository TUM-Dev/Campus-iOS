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
}
