//
//  StudyRoomWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 01.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct StudyRoomWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> StudyRoomWidgetEntry {
        let vm = await StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
        await vm.fetch()
        
        let entry = await StudyRoomWidgetEntry(
            name: vm.studyGroup?.name,
            rooms: vm.rooms,
            coordinate: vm.studyGroup?.coordinate
        )
        
        return entry
    }
    
    func placeholder(in context: Context) -> StudyRoomWidgetEntry {
        return StudyRoomWidgetEntry.mockEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StudyRoomWidgetEntry) -> ()) {
        Task {
            let entry = await entry()
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<StudyRoomWidgetEntry>) -> ()) {
        Task {
            let entry = await entry()
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
            completion(timeline)
        }
    }
}

struct StudyRoomWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let name: String?
    let rooms: [StudyRoom]?
    let coordinate: CLLocationCoordinate2D?
    
    init() {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.name = nil
        self.rooms = nil
        self.coordinate = nil
    }
    
    init(name: String?, rooms: [StudyRoom]?, coordinate: CLLocationCoordinate2D?) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.name = name
        self.rooms = rooms
        self.coordinate = coordinate
    }
    
    static let mockEntry = StudyRoomWidgetEntry(
        name: "Some StudiTUM",
        rooms: [],
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 11)
    )
}

struct StudyRoomWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: StudyRoomWidgetProvider.Entry

    var body: some View {
        if let name = entry.name, let coordinate = entry.coordinate {
            StudyRoomWidgetContent(
                size: WidgetSize.from(widgetFamily: widgetFamily),
                name: name,
                rooms: entry.rooms ?? [],
                coordinate: coordinate
            )
            .widgetBackground()
        } else {
            Text("There was an error fetching the widget content.")
        }
    }
}

struct StudyRoomWidget: Widget {
    let kind = "studyroom-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: StudyRoomWidgetProvider()) { entry in
            StudyRoomWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Study Room Widget")
        .description("Displays the availability of study rooms in the nearest study room building.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct StudyRoomWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        StudyRoomWidgetEntryView(entry: StudyRoomWidgetEntry.mockEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

