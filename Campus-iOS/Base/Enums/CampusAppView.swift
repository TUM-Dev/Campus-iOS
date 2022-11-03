//
//  CampusAppView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 30.10.22.
//

import Foundation

/* Views for which we gather usage data for the widget recommendations. */
enum CampusAppView: String, CaseIterable {
    case cafeteria = "cafeteria",
         cafeterias = "cafeterias",
         calendar = "calendar",
         calendarEvent = "calendarEvent",
         grades = "grades",
         studyRoom = "studyRoom",
         studyRooms = "studyRooms",
         tuition = "tuition"
}
