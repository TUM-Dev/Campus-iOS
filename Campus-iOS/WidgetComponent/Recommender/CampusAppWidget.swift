//
//  Widget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation

enum CampusAppWidget: CaseIterable {
    case cafeteria, studyRoom, calendar, tuition, grades
    
    // Views associated to the widget in some way.
    // We can use this to make assumptions for widget recommendations, based on the views that the user visited.
    func associatedViews() -> [CampusAppView] {
        switch self {
        case .cafeteria:
            return [.cafeterias, .cafeteria]
        case .studyRoom:
            return [.studyRooms, .studyRoom]
        case .calendar:
            return [.calendar, .calendarEvent]
        case .tuition:
            return [.tuition]
        case .grades:
            return [.grades]
        }
    }
}
