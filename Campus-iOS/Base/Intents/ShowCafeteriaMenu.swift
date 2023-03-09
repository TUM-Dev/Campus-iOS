//
//  ShowCafeteriaMenu.swift
//  Campus-iOS
//
//  Created by Moritz on 09.03.23.
//

import AppIntents

struct ShowCafeteriaMenu: AppIntent {
    static var title: LocalizedStringResource = "Show the cafeteria menu"
    
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
        Model.shared.isLoginSheetPresented = false
        Model.shared.selectedTab = .places
        return .result(dialog: "Opening today's menu for \(cafeteria.name)")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open the meal plan for \(\.$cafeteria)")
    }
}
