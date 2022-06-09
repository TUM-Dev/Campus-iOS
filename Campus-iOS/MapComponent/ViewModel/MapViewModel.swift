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
    @Published var cafeteriasState: CafeteriasNetworkState = .na
    @Published var studyRoomsState: StudyRoomsNetworkState = .na
    @Published var hasError: Bool = false
  
    @Published var zoomOnUser: Bool = true
    @Published var panelPosition: String = "pushMid"
    @Published var lockPanel: Bool = false
    @Published var selectedCafeteriaName: String = " "
    @Published var selectedAnnotationIndex: Int = 0
    @Published var selectedCafeteria: Cafeteria?
    
    @Published var selectedStudyGroupName: String = " "
    @Published var selectedStudyRoomGroup: StudyRoomGroup?
    
    private let mock: Bool
    
    private let cafeteriaService: CafeteriasServiceProtocol
    private let studyRoomsService: StudyRoomsServiceProtocol
    
    var cafeterias: [Cafeteria] {
        get {
            if mock {
                return mockCafeterias
            } else {
                guard case .success(let cafeterias) = self.cafeteriasState else {
                    return []
                }
                return cafeterias
            }
        }
        set {
            self.cafeterias = newValue
        }
    }
    
    var studyRoomsResponse: StudyRoomApiRespose {
        get {
            if mock {
                return StudyRoomApiRespose()
            } else {
                guard case .success(let studyRoomsResponse) = self.studyRoomsState else {
                    return StudyRoomApiRespose()
                }
                return studyRoomsResponse
            }
        }
        set {
            self.studyRoomsResponse = newValue
        }
    }
    
    init(cafeteriaService: CafeteriasServiceProtocol, studyRoomsService: StudyRoomsServiceProtocol, mock: Bool = false) {
        self.cafeteriaService = cafeteriaService
        self.studyRoomsService = studyRoomsService
        self.mock = mock
    }
    
    func getCafeteria(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.cafeteriasState = .loading
        }
        
        self.hasError = false
        
        do {
            //@MainActor handles to run this UI-updating task on the main thread
            let data = try await cafeteriaService.fetch(forcedRefresh: forcedRefresh)
            self.cafeteriasState = .success(data: data)
        } catch {
            self.cafeteriasState = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getStudyRoomResponse(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.cafeteriasState = .loading
        }
        
        self.hasError = false
        
        do {
            //@MainActor handles to run this UI-updating task on the main thread
            let data = try await cafeteriaService.fetch(forcedRefresh: forcedRefresh)
            self.cafeteriasState = .success(data: data)
        } catch {
            self.cafeteriasState = .failed(error: error)
            self.hasError = true
        }
    }
}
