//
//  NavigaTumViewModel.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.01.23.
//
import Foundation
import Alamofire
import XMLCoder

class NavigaTumViewModel: ObservableObject {
    @Published var searchResults: [NavigaTumNavigationEntity] = []
    @Published var errorMessage: String = ""

    @MainActor func fetch(searchString: String) async {
        guard !searchString.isEmpty else {
            self.errorMessage = ""
            return
        }
        do {
            let results = try await RoomFinderService().search(query: searchString)
            self.searchResults = results.sections.flatMap(\.entries)
        } catch {
            self.errorMessage = "Room Service Failed"
        }
    }
}
