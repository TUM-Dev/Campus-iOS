//
//  MapViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Wenner and David Lin on 14.05.22.
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
    @Published var panelPosition: String = "pushMid"
    @Published var lockPanel: Bool = false
    @Published var selectedCafeteriaName: String = " "
    @Published var selectedAnnotationIndex: Int = 0
    @Published var selectedCafeteria: Cafeteria?
    
    private let mock: Bool
    
    private let service: CafeteriasServiceProtocol
    
    var cafeterias: [Cafeteria] {
        get {
            if mock {
                return mockCafeterias
            } else {
                guard case .success(let cafeterias) = self.state else {
                    return []
                }
                return cafeterias
            }
        }
        set {
            self.cafeterias = newValue
        }
    }
    
    init(service: CafeteriasServiceProtocol, mock: Bool = false) {
        self.service = service
        self.mock = mock
    }
    
    func getCafeteria(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        
        self.hasError = false
        
        do {
            //@MainActor handles to run this UI-updating task on the main thread
            let data = try await service.fetch(forcedRefresh: forcedRefresh)
            self.state = .success(data: data)
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
