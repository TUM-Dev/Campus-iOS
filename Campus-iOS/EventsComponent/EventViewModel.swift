//
//  EventViewModel.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var allTalks: [TUMEvent] = []
    @Published var errorMessage: String = ""
    
    @MainActor func fetch() async {
        do {
            self.allTalks = try await EventsService().talks()
        } catch {
            self.errorMessage = "Events Service Failed"
        }
    }
}
