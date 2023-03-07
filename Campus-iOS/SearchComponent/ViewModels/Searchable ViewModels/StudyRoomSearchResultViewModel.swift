//
//  StudyRoomSearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct StudyRoomSearchResult: Searchable {
    var comparisonTokens: [ComparisonToken] {
        return group.comparisonTokens + rooms.flatMap {$0.comparisonTokens}
    }
    
    let group: StudyRoomGroup
    let rooms: [StudyRoom]
    
    static func == (lhs: StudyRoomSearchResult, rhs: StudyRoomSearchResult) -> Bool {
        lhs.group.id == rhs.group.id
    }
}

extension StudyRoomSearchResultViewModel {
    enum State {
        case na
        case loading
        case success(data: [(studyRoomResult: StudyRoomSearchResult, distance: Distances)])
        case failed(error: Error)
    }
}

@MainActor
class StudyRoomSearchResultViewModel: ObservableObject {
    @Published var state: State = .na
    @Published var hasError = false
    private let studyRoomService: StudyRoomsServiceProtocol
    
    init(studyRoomService: StudyRoomsServiceProtocol) {
        self.studyRoomService = studyRoomService
    }
    
    func studyRoomSearch(for query: String, forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            let data = try await studyRoomService.fetch(forcedRefresh: forcedRefresh)
            
            guard let groups = data.groups, let rooms = data.rooms else {
                self.state = .failed(error: SearchError.empty(searchQuery: query))
                self.hasError = true
                return
            }
            
            let groupRooms: [StudyRoomSearchResult] = groups.map { currentGroup in
                let currentRooms = rooms.filter {
                    return currentGroup.rooms?.contains($0.id) ?? false
                }
                
                return StudyRoomSearchResult(group: currentGroup, rooms: currentRooms)
            }
            
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: groupRooms) {
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
