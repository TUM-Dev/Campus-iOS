//
//  MapViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 14.05.22.
//

import Foundation

protocol MapViewModelProtocol: ObservableObject {
    func getCafeteria(forcedRefresh: Bool) async
}

@MainActor
class MapViewModel: MapViewModelProtocol {
    // State for fetching cafeterias
    @Published var state: State = .na
    @Published var hasError: Bool = false
    
    @Published var zoomOnUser: Bool = true
    @Published var panelPosition: String = "down"
    @Published var selectedCanteenName: String = " "
    @Published var selectedAnnotationIndex: Int = 0
    @Published var selectedCanteen: Cafeteria = Cafeteria(location: Location(latitude: 0, longitude: 0, address: " "), name: " ", id: " ", queueStatusApi: nil)
    
    private let service: CafeteriasServiceProtocol
    
    var cafeterias: [Cafeteria] {
        get {
            guard case .success(let cafeterias) = self.state else {
                return []
            }
            return cafeterias
        }
        set {
            
        }
    }
    
    init(service: CafeteriasServiceProtocol) {
        self.service = service
    }
    
    func getCafeteria(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        
        self.hasError = false
        
        do {
            //@MainActor handles to run this UI-updating task on the main thread
            let x = try await service.fetch(forcedRefresh: forcedRefresh)
            self.state = .success(data: x)
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
