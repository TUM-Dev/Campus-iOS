//
//  CalendarWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 02.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct CalendarWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> CalendarWidgetEntry {
        let vm = await CalendarWidgetViewModel()
        await vm.fetch()
        
        let entry = await CalendarWidgetEntry(events: vm.upcomingEvents())
        
        return entry
    }
    
    func placeholder(in context: Context) -> CalendarWidgetEntry {
        return CalendarWidgetEntry.mockEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CalendarWidgetEntry) -> ()) {
        Task {
            let entry = await entry()
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> ()) {
        Task {
            let entry = await entry()
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
            completion(timeline)
        }
    }
}

struct CalendarWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let events: [CalendarEvent]?
    
    init() {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.events = nil
    }
    
    init(events: [CalendarEvent]?) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.events = events
    }
    
    static let mockEntry = CalendarWidgetEntry(events: [CalendarEvent](repeating: CalendarEvent.mockEvent, count: 5))
}

struct CalendarWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: CalendarWidgetProvider.Entry

    var body: some View {
        if let events = entry.events {
            CalendarWidgetContent(
                size: WidgetSize.from(widgetFamily: widgetFamily),
                events: events
            )
            .widgetBackground()
        } else {
            Text("There was an error fetching the widget content.")
        }
    }
}

struct CalendarWidget: Widget {
    let kind = "calendar-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: CalendarWidgetProvider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("Displays your schedule.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarWidgetEntryView(entry: CalendarWidgetEntry.mockEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

