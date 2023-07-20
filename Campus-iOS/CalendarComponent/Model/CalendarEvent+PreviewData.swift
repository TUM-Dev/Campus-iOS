//
//  CalendarEvent+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

extension CalendarEvent {
    
    static let mockEvent = CalendarEvent(
        id: 1,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950369994"),
        title: "Programmoptimierung (IN2053) VI",
        descriptionText: "fix; Abhaltung; ",
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60),
        location: "00.13.009A, Seminarraum (5613.EG.009A)"
    )
    
    static let previewData = [
        CalendarEvent(
        id: 889413054,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950630619"),
        title: "Grundlagen: Betriebssysteme und Systemsoftware (IN0009) VO",
        descriptionText: "fix; Abhaltung; ",
        startDate: DateFormatter.yyyyMMddhhmmss.date(from: "2022-12-21 13:00:00") ?? Date(),
        endDate: DateFormatter.yyyyMMddhhmmss.date(from: "2022-12-21 14:00:00") ?? Date().addingTimeInterval(60 * 60),
        location: "MW 0001, Gustav-Niemann-Hörsaal (5510.EG.001)"
        ),
        CalendarEvent(
        id: 889461603,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950629892"),
        title: "Analysis für Informatik [MA0902] VO",
        descriptionText: "fix; Abhaltung; ",
        startDate: DateFormatter.yyyyMMddhhmmss.date(from: "2022-12-22 08:30:00") ?? Date(),
        endDate: DateFormatter.yyyyMMddhhmmss.date(from: "2022-12-22 10:00:00") ?? Date().addingTimeInterval(60 * 60),
        location: "MW 0001, Gustav-Niemann-Hörsaal (5510.EG.001)"
        ),
        CalendarEvent(
        id: 889413025,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950630619"),
        title: "Grundlagen: Betriebssysteme und Systemsoftware (IN0009) VO",
        descriptionText: "fix; Abhaltung; ",
        startDate: DateFormatter.yyyyMMddhhmmss.date(from: "2023-01-09 13:45:00") ?? Date(),
        endDate: DateFormatter.yyyyMMddhhmmss.date(from: "2023-01-09 15:15:00") ?? Date().addingTimeInterval(60 * 60),
        location: "MW 2001 Rudolf-Diesel-Hörsaal (5510.02.001)"
        ),
        CalendarEvent(
        id: 889461590,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950629892"),
        title: "Analysis für Informatik [MA0902] VO",
        descriptionText: "fix; Abhaltung; ",
        startDate: DateFormatter.yyyyMMddhhmmss.date(from: "2023-01-10 08:30:00") ?? Date(),
        endDate: DateFormatter.yyyyMMddhhmmss.date(from: "2023-01-10 10:00:00") ?? Date().addingTimeInterval(60 * 60),
        location: "MW 0001, Gustav-Niemann-Hörsaal (5510.EG.001)"
        ),
    
    ]
}
