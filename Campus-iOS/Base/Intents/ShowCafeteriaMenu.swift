//
//  ShowCafeteriaMenu.swift
//  Campus-iOS
//
//  Created by Moritz on 09.03.23.
//

import AppIntents

struct ShowCafeteriaMenu: AppIntent {
    static var title: LocalizedStringResource = "Open cafeteria menu"
    
    static var openAppWhenRun = true
    
    @Parameter(title: "Cafeteria", requestValueDialog: "For which cafeteria?")
    var cafeteria: Cafeteria
    
    init() {
        // Required stub
    }
    
    init(cafeteria: Cafeteria) {
        self.cafeteria = cafeteria
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result(value: cafeteria, dialog: "Opening today's menu for \(cafeteria.name)")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open the meal plan for \(\.$cafeteria)")
    }
}
