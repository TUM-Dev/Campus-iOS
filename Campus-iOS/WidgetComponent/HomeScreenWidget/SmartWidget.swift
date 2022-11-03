//
//  SmartWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 03.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct SmartWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> SmartWidgetEntry {
        
        let strategy = SpatioTemporalStrategy()
        
        // Fall back to calendar widget if there are no recommendations.
        guard let recommendations = try? await strategy.getRecommendation(),
              let widget = recommendations.max (by: { $0.priority < $1.priority })?.widget
        else {
            let calendarProvider = CalendarWidgetProvider()
            let calendarEntry = await calendarProvider.entry()
            return SmartWidgetEntry(entry: calendarEntry)
        }
        
        let contentEntry = await contentEntry(for: widget)
        return SmartWidgetEntry(entry: contentEntry)
    }
    
    private func contentEntry(for widget: CampusAppWidget) async -> TimelineEntry {
        switch widget {
        case .cafeteria:
            return await CafeteriaWidgetProvider().entry()
        case .calendar:
            return await CalendarWidgetProvider().entry()
        case .grades:
            return await GradeWidgetProvider().entry()
        case .studyRoom:
            return await StudyRoomWidgetProvider().entry()
        case .tuition:
            return await TuitionWidgetProvider().entry()
        }
    }
    
    func placeholder(in context: Context) -> SmartWidgetEntry {
        return SmartWidgetEntry(entry: CalendarWidgetEntry.mockEntry)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SmartWidgetEntry) -> ()) {
        Task {
            let entry = await entry()
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let entry = await entry()
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
            completion(timeline)
        }
    }
}

struct SmartWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let entry: TimelineEntry
    
    init(entry: TimelineEntry) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.entry = entry
    }
    
    @ViewBuilder
    func entryView() -> some View {
        if let concreteEntry = entry as? CafeteriaWidgetEntry {
            CafeteriaWidgetEntryView(entry: concreteEntry)
        } else if let concreteEntry = entry as? CalendarWidgetEntry {
            CalendarWidgetEntryView(entry: concreteEntry)
        } else if let concreteEntry = entry as? GradeWidgetEntry {
            GradeWidgetEntryView(entry: concreteEntry)
        } else if let concreteEntry = entry as? StudyRoomWidgetEntry {
            StudyRoomWidgetEntryView(entry: concreteEntry)
        } else if let concreteEntry = entry as? TuitionWidgetEntry {
            TuitionWidgetEntryView(entry: concreteEntry)
        } else {
            Text("Error")
                .widgetBackground()
        }
    }
}

struct SmartWidget: Widget {
    let kind = "smart-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: SmartWidgetProvider()) { entry in
            entry.entryView()
        }
        .configurationDisplayName("Smart Widget")
        .description("Displays what is relevant to you.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
