//
//  AppShortcuts.swift
//  Campus-iOS
//
//  Created by Moritz on 09.03.23.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    
    static var shortcutTileColor: ShortcutTileColor = .navy
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowCafeteriaMenu(),
            phrases: [
                "Show \(\.$cafeteria) in \(.applicationName)",
                "Ask \(.applicationName) what to eat on campus?",
                "Ask \(.applicationName) what is on today's menu at \(\.$cafeteria)",
                "Show the menu at \(\.$cafeteria) in \(.applicationName)",
                "Meal plan at \(\.$cafeteria) in \(.applicationName)",
            ],
            systemImageName: "mappin.and.ellipse"
        )
        AppShortcut(
            intent: ShowGrades(),
            phrases: [
                "Show my grades in \(.applicationName)",
                "Show my grade report in \(.applicationName)",
                "Show the exam results in \(.applicationName)",
            ],
            systemImageName: "checkmark.shield"
        )
        AppShortcut(
            intent: OpenCalendar(),
            phrases: [
                "Open the university calendar in \(.applicationName)",
                "Open \(.applicationName) calendar",
            ],
            systemImageName: "calendar"
        )
        AppShortcut(
            intent: ShowLectures(),
            phrases: [
                "Show my lectures in \(.applicationName)",
                "Show \(.applicationName) lectures",
            ],
            systemImageName: "studentdesk"
        )
    }
}
