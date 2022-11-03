//
//  TuitionWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 01.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct TuitionWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> TuitionWidgetEntry {
        let vm = await TuitionWidgetViewModel()
        await vm.fetch()
        
        let entry = await TuitionWidgetEntry(
            amount: vm.tuition?.amount,
            deadline: vm.tuition?.deadline,
            semesterID: vm.tuition?.semesterID
        )
        return entry
    }
    
    func placeholder(in context: Context) -> TuitionWidgetEntry {
        return TuitionWidgetEntry.mockEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TuitionWidgetEntry) -> ()) {
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

struct TuitionWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let amount: NSDecimalNumber?
    let deadline: Date?
    let semesterID: String?
    
    init() {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.amount = nil
        self.deadline = nil
        self.semesterID = nil
    }
    
    init(amount: NSDecimalNumber?, deadline: Date?, semesterID: String?) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.amount = amount
        self.deadline = deadline
        self.semesterID = semesterID
    }
    
    static let mockEntry = TuitionWidgetEntry(
        amount: 138.0,
        deadline: Date(),
        semesterID: "22W"
    )
}

struct TuitionWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: TuitionWidgetProvider.Entry

    var body: some View {
        if let amount = entry.amount, let deadline = entry.deadline, let semesterID = entry.semesterID {
            TuitionWidgetContent(
                size: WidgetSize.from(widgetFamily: widgetFamily),
                amount: amount,
                deadline: deadline,
                semesterID: semesterID
            )
            .widgetBackground()
        } else {
            Text("There was an error fetching the widget content.")
        }
    }
}

struct TuitionWidget: Widget {
    let kind = "tuition-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: TuitionWidgetProvider()) { entry in
            TuitionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tuition Reminder Widget")
        .description("Displays your open tuition fee amount.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TuitionWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        TuitionWidgetEntryView(entry: TuitionWidgetEntry.mockEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

