//
//  StudyRoomApiResponse+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

extension StudyRoomApiRespose {
    static let previewData: StudyRoomApiRespose = StudyRoomApiRespose(
        rooms: [
StudyRoom(buildingCode: "5603", buildingName: "FMI/ Bibliothek", buildingNumber: 832, code: "01.03.010", id: 49770, name: "Windfang", number: "010", occupiedBy: "", occupiedFor: 0, occupiedFrom: "", occupiedIn: 0, occupiedUntil: "", raum_nr_architekt: "01.03.010@5603", res_nr: 27052, status: "frei", attributes: []),
        StudyRoom(buildingCode: "5603", buildingName: "FMI/ Bibliothek", buildingNumber: 832, code: "01.03.010", id: 58380, name: "Einzelarbeitsraum", number: "043B", occupiedBy: "", occupiedFor: 0, occupiedFrom: "", occupiedIn: 0, occupiedUntil: "", raum_nr_architekt: "01.03.043B@5603", res_nr: 26714, status: "frei", attributes: [])],
        groups: [
            StudyRoomGroup(detail: "", id: 46, name: "Fachschaftsräume Mathe/Informatik", sorting: 1, rooms: [49770,58380,58372,58363,58354,58346,58227,58217,58211,58203,58195,58187,58068,58059,58050,58041])])

}
