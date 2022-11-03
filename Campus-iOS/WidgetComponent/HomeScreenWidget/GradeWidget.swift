//
//  GradeWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 02.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct GradeWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> GradeWidgetEntry {
        let vm = await GradesViewModel(model: Model(), service: GradesService())
        await vm.getGrades()
        
        let entry = await GradeWidgetEntry(
            grades: vm.grades
        )
        
        return entry
    }
    
    func placeholder(in context: Context) -> GradeWidgetEntry {
        return GradeWidgetEntry.mockEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (GradeWidgetEntry) -> ()) {
        Task {
            let entry = await entry()
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<GradeWidgetEntry>) -> ()) {
        Task {
            let entry = await entry()
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
            completion(timeline)
        }
    }
}

struct GradeWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let grades: [Grade]?
    
    init() {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.grades = nil
    }
    
    init(grades: [Grade]?) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.grades = grades
    }
    
    static let mockEntry = GradeWidgetEntry(grades: Grade.dummyData)
}

struct GradeWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: GradeWidgetProvider.Entry

    var body: some View {
        if let grades = entry.grades {
            GradeWidgetContent(
                size: WidgetSize.from(widgetFamily: widgetFamily),
                grades: grades
            )
            .widgetBackground()
        } else {
            Text("There was an error fetching the widget content.")
        }
    }
}

struct GradeWidget: Widget {
    let kind = "grade-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: GradeWidgetProvider()) { entry in
            GradeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Grades Widget")
        .description("Displays your most recent grades.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct GradeWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        GradeWidgetEntryView(entry: GradeWidgetEntry.mockEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

