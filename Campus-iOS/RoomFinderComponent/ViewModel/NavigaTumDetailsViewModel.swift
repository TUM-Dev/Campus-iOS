//
//  NavigaTumDetailsViewModel.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.01.23.
//
import Foundation

import Foundation
import Alamofire
import XMLCoder

class NavigaTumDetailsViewModel: ObservableObject {
    @Published var details: NavigaTumNavigationDetails?
    @Published var errorMessage = ""
    let id: String

    init(id: String) {
        self.id = id
    }

    @MainActor func fetchDetails() async {
        guard !id.isEmpty else {
            self.errorMessage = "Couldn't fetch room details"
            return
        }
        do {
            self.details = try await RoomFinderService().details(id: id)
        } catch {
            self.errorMessage = "Room finder service failed"
        }
    }
}
