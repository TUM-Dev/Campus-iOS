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

@MainActor
class StudyRoomSearchResultViewModel: ObservableObject {
    @Published var results = [(studyRoomResult: StudyRoomSearchResult, distance: Distances)]()
    private let studyRoomService: StudyRoomsServiceProtocol = StudyRoomsService()
    
    func studyRoomSearch(for query: String) async {
        let studyRoomsResponse = await fetch()
        
        guard let groups = studyRoomsResponse.groups, let rooms = studyRoomsResponse.rooms else {
            return
        }
        
        
        
        let groupRooms: [StudyRoomSearchResult] = groups.map { currentGroup in
            let currentRooms = rooms.filter {
                return currentGroup.rooms?.contains($0.id) ?? false
            }
            
            return StudyRoomSearchResult(group: currentGroup, rooms: currentRooms)
        }
//        rint(">> GROUPS: \(groupRooms)")
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: groupRooms) {
            
            self.results = optionalResults
            print(">> StudyRoomResults: \(results)")
        }
    }
    
    func fetch() async -> StudyRoomApiRespose {
        
        var studyRoomResponse = StudyRoomApiRespose()
        do {
            studyRoomResponse = try await studyRoomService.fetch(forcedRefresh: false)
        } catch {
            print("No studyRooms were fetched")
        }
        
        return studyRoomResponse
    }
}
