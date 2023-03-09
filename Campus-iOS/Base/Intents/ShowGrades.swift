//
//  ShowGrades.swift
//  Campus-iOS
//
//  Created by Moritz on 09.03.23.
//

import AppIntents

struct ShowGrades: AppIntent {
    static var title: LocalizedStringResource = "Show my grades"
    
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Model.shared.selectedTab = .grades
        return .result(dialog: "Opening your grade report")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open the grade report")
    }
}
