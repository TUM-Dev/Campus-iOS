//
//  StudyRoomManager.swift
//  TUM Campus App
//
//  Created by Max Muth on 17.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class StudyRoomsManager: Manager {
    
    static var studyRooms = [StudyRoom]()
    static var groups = [StudyRoomGroup]()
    
    required init(mainManager: TumDataManager) {
        
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if (!StudyRoomsManager.studyRooms.isEmpty || !StudyRoomsManager.groups.isEmpty) {
            handleStudyRooms(handler)
            return
        }
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            Alamofire.request(getURL(), method: .get, parameters: nil,
                              headers: ["X-DEVICE-ID": uuid]).responseJSON() { (response) in
                                if let data = response.result.value {
                                    if let json = JSON(data).dictionary {
                                        if let rooms = json["raeume"]?.array {
                                            for roomItem in rooms {
                                                if let studyRoom = StudyRoom(from: roomItem) {
                                                    StudyRoomsManager.studyRooms.append(studyRoom)
                                                }
                                            }
                                        }
//                                        if let groups = json["gruppen"]?.array {
//                                            for groupItem in groups {
//                                                if let group = StudyRoomGroup(from: groupItem) {
//                                                    StudyRoomManager.groups.append(group)
//                                                }
//                                            }
//                                        }
                                        self.handleStudyRooms(handler)
                                    }
                                }
            }
        }
    }

    func handleStudyRooms(_ handler: ([DataElement]) -> ()) {
//        let sortedGroups = StudyRoomManager.groups.sorted { $0.sortId < $1.sortId }
        let freeRooms = StudyRoomsManager.studyRooms.filter { $0.status == StudyRoomStatus.Free }
        let occupiedRooms = StudyRoomsManager.studyRooms.filter { $0.status == StudyRoomStatus.Occupied }
        handler(freeRooms + occupiedRooms)
    }
    
    func getURL() -> String {
        return StudyRoomApi.BaseUrl.rawValue + StudyRoomApi.AllRoomsAndGroups.rawValue
    }
    
}
    
