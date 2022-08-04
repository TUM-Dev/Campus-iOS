//
//  MapViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Wenner and David Lin on 14.05.22.
//

import Foundation
import UIKit

protocol MapViewModelProtocol: ObservableObject {
    func getCafeteria(forcedRefresh: Bool) async
}

enum MapMode: CaseIterable {
    case cafeterias, studyRooms
}

@MainActor
class MapViewModel: MapViewModelProtocol {
    // State for fetching cafeterias
    @Published var cafeteriasState: CafeteriasNetworkState = .na
    @Published var studyRoomsState: StudyRoomsNetworkState = .na
    @Published var hasError = false
  
    @Published var zoomOnUser = true
    @Published var lockPanel = false
    @Published var mode: MapMode = .cafeterias
    @Published var setAnnotations = true
    
    @Published var selectedCafeteriaName = " "
    @Published var selectedAnnotationIndex = 0
    @Published var selectedCafeteria: Cafeteria?
    
    @Published var selectedStudyGroup: StudyRoomGroup?
    
    @Published var panelPos: PanelPos = .middle
    
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
            self.studyRoomsState = .loading
        }
        
        self.hasError = false
        
        do {
            //@MainActor handles to run this UI-updating task on the main thread
            let data = try await studyRoomsService.fetch(forcedRefresh: forcedRefresh)
            self.studyRoomsState = .success(data: data)
        } catch {
            self.studyRoomsState = .failed(error: error)
            self.hasError = true
        }
    }
}

enum PanelHeight {
    static let top = UIScreen.main.bounds.height * 0.8
    static let kbtop = UIScreen.main.bounds.height * 0.7
    static let middle = UIScreen.main.bounds.height * 0.35
    static let bottom = UIScreen.main.bounds.height * 0.2
}

let screenHeight = UIScreen.main.bounds.height

enum PanelPos {
    case top, kbtop, middle, bottom
    var rawValue: CGFloat {
        switch self {
        case .top: return screenHeight * 0.8
        case .kbtop: return screenHeight * 0.7
        case .middle: return screenHeight * 0.35
        case .bottom: return screenHeight * 0.2
        }
    }
}
