//
//  ShowLectures.swift
//  Campus-iOS
//
//  Created by Moritz on 11.03.23.
//

import AppIntents

struct ShowLectures: AppIntent {
    static var title: LocalizedStringResource = "Show my lectures"
    
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Model.shared.selectedTab = .lectures
        return .result(dialog: "Opening your lectures")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open the lecture overview")
    }
}
