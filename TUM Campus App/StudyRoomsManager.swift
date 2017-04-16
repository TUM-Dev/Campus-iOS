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
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            Alamofire.request(getURL(), method: .get, parameters: nil,
                              headers: ["X-DEVICE-ID": uuid]).responseJSON() { (response) in
                                if let data = response.result.value {
                                    if let json = JSON(data).dictionary {
                                        if let rooms = json["raeume"]?.array {
                                            StudyRoomsManager.studyRooms = rooms.flatMap(StudyRoom.init)
                                        }
                                        if let groups = json["gruppen"]?.array {
                                            StudyRoomsManager.groups = groups.flatMap(StudyRoomGroup.init)
                                        }
                                        self.handleStudyRooms(handler)
                                    }
                                }
            }
        }
    }

    func handleStudyRooms(_ handler: ([DataElement]) -> ()) {
        let sortedGroups = StudyRoomsManager.groups.sorted { $0.sortId < $1.sortId }
        handler(sortedGroups)
        handler(StudyRoomsManager.studyRooms)
    }
    
    func getURL() -> String {
        return StudyRoomApi.BaseUrl.rawValue + StudyRoomApi.AllRoomsAndGroups.rawValue
    }
    
}
    
