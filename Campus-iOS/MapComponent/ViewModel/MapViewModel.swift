//
//  MapViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Wenner and David Lin on 14.05.22.
//

import Foundation
import UIKit
import CoreData

protocol MapViewModelProtocol: ObservableObject {
    func getCafeteria(forcedRefresh: Bool) async
}

enum MapMode: CaseIterable {
    case cafeterias, studyRooms
}

@MainActor
class MapViewModel: NSObject, MapViewModelProtocol {
    
    @Published var studyRooms = [StudyRoomCoreData]()
    @Published var studyRoomGroups = [StudyRoomGroupCoreData]()
    
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
    
    private let context: NSManagedObjectContext
    
    private let studyRoomFetchedResultController: NSFetchedResultsController<StudyRoomCoreData>
    private let studyRoomGroupFetchedResultController: NSFetchedResultsController<StudyRoomGroupCoreData>
    
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
    
    init(context: NSManagedObjectContext? = nil, cafeteriaService: CafeteriasServiceProtocol, studyRoomsService: StudyRoomsServiceProtocol, mock: Bool = false) {
        self.cafeteriaService = cafeteriaService
        self.studyRoomsService = studyRoomsService
        self.mock = mock
        if let context = context {
            self.context = context
            self.studyRoomFetchedResultController = NSFetchedResultsController(fetchRequest: StudyRoomCoreData.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.studyRoomGroupFetchedResultController = NSFetchedResultsController(fetchRequest: StudyRoomGroupCoreData.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            self.context = NSManagedObjectContext()
            self.studyRoomFetchedResultController = NSFetchedResultsController()
            self.studyRoomGroupFetchedResultController = NSFetchedResultsController()
        }
        
        super.init()
        studyRoomFetchedResultController.delegate = self
        
        do {
            try studyRoomFetchedResultController.performFetch()
            guard let studyRooms = studyRoomFetchedResultController.fetchedObjects else {
                return
            }
            
            self.studyRooms = studyRooms
//            self.state = .success
        } catch {
//            self.state = .failed(error: error)
//            self.hasError = true
            print(error)
        }
        
        studyRoomGroupFetchedResultController.delegate = self
        
        do {
            try studyRoomGroupFetchedResultController.performFetch()
            guard let studyRoomGroups = studyRoomGroupFetchedResultController.fetchedObjects else {
                return
            }
            
            self.studyRoomGroups = studyRoomGroups
//            self.state = .success
        } catch {
//            self.state = .failed(error: error)
//            self.hasError = true
            print(error)
        }
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
            setAnnotations = true
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
            setAnnotations = true
        } catch {
            self.studyRoomsState = .failed(error: error)
            self.hasError = true
        }
    }
    
    func getRoomsAndGrous() async {
        
        do {
            try await studyRoomsService.fetch(context: self.context)
        } catch {
            print(error)
        }
        
//        
//        var studyRoomApiResponse = StudyRoomApiRespose()
//        do {
//            studyRoomApiResponse = try await studyRoomsService.fetch(forcedRefresh: true)
//        } catch {
//            print(error)
//        }
//
//        let _: [StudyRoomCoreData]? = studyRoomApiResponse.rooms?.compactMap({ studyRoom in
//
//            let newRoom = StudyRoomCoreData(context: context)
//
//            newRoom.occupiedFrom = studyRoom.occupiedFrom
//            newRoom.occupiedUntil = studyRoom.occupiedUntil
//            newRoom.occupiedBy = studyRoom.occupiedBy
//            newRoom.occupiedFor = studyRoom.occupiedFor
//            newRoom.occupiedIn = studyRoom.occupiedIn
//            newRoom.buildingCode = studyRoom.buildingCode
//            newRoom.buildingName = studyRoom.buildingName
//            newRoom.buildingNumber = studyRoom.buildingNumber
//            newRoom.code = studyRoom.code
//            newRoom.name = studyRoom.name
//            newRoom.id = studyRoom.id
//            newRoom.raum_nr_architekt = studyRoom.raum_nr_architekt
//            newRoom.number = studyRoom.number
//            newRoom.res_nr = studyRoom.res_nr
//            newRoom.status = studyRoom.status
//            newRoom.attributes = studyRoom.attributes
//
//            return newRoom
//
//        })
//
//        let _: [StudyRoomGroupCoreData]? = studyRoomApiResponse.groups?.compactMap({ studyRoomGroup in
//
//            let newGroup = StudyRoomGroupCoreData(context: context)
//
//            newGroup.detail = studyRoomGroup.detail
//            newGroup.name = studyRoomGroup.name
//            newGroup.id = studyRoomGroup.id
//            newGroup.sorting = studyRoomGroup.sorting
//            newGroup.rooms = studyRoomGroup.rooms
//
//            return newGroup
//
//        })
//
//        // Saving the data into CoreData
//        do {
//            try context.save()
//        } catch {
//            print(String(describing: error))
//        }
//
    }
}

extension MapViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        print(controller.fetchedObjects)
 
        if let studyRooms = controller.fetchedObjects as? [StudyRoomCoreData] {
            self.studyRooms = studyRooms
//            self.state = .success
        }
        
        if let studyRoomGroups = controller.fetchedObjects as? [StudyRoomGroupCoreData] {
            self.studyRoomGroups = studyRoomGroups
//            self.state = .success
        }
    }
}

let screenHeight = UIScreen.main.bounds.height

enum PanelHeight {
    static let top = screenHeight * 0.82
    static let middle = screenHeight * 0.35
    static let bottom = screenHeight * 0.08
}

enum PanelPos {
    case top, middle, bottom
    var rawValue: CGFloat {
        switch self {
        case .top: return screenHeight * 0.82
        case .middle: return screenHeight * 0.35
        case .bottom: return screenHeight * 0.08
        }
    }
}
