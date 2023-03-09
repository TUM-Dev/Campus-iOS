//
//  AutoShortcuts.swift
//  Campus-iOS
//
//  Created by Moritz on 09.03.23.
//

import AppIntents

struct AutoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowCafeteriaMenu(),
            phrases: [
                "Show the menu at \(\.$cafeteria)",
                "What is on today's menu at \(\.$cafeteria)",
                "Meal plan at \(\.$cafeteria)",
                "Show \(\.$cafeteria) in \(.applicationName)",
            ],
            systemImageName: "books.vertical.fill"
        )
    }
}
