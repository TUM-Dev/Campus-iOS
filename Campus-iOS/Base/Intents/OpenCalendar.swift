//
//  OpenCalendar.swift
//  Campus-iOS
//
//  Created by Moritz on 11.03.23.
//

import AppIntents

struct OpenCalendar: AppIntent {
    static var title: LocalizedStringResource = "Open the calendar"
    
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Model.shared.selectedTab = .calendar
        return .result(dialog: "Opening the TUM calendar")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open the calendar")
    }
}
