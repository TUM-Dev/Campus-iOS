//
//  CafeteriaWidget.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 01.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct CafeteriaWidgetProvider: IntentTimelineProvider {
    
    func entry() async -> CafeteriaWidgetEntry {
        let vm = await CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
        await vm.fetch()
        
        let entry = await CafeteriaWidgetEntry(
            cafeteriaName: vm.cafeteria?.title,
            dishes: vm.menuViewModel?.getDishes(),
            coordinate: vm.cafeteria?.coordinate
        )
        
        return entry
    }
    
    func placeholder(in context: Context) -> CafeteriaWidgetEntry {
        return CafeteriaWidgetEntry.mockEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CafeteriaWidgetEntry) -> ()) {
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

struct CafeteriaWidgetEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    
    let cafeteriaName: String?
    let dishes: [Dish]?
    let coordinate: CLLocationCoordinate2D?
    
    init() {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.cafeteriaName = nil
        self.dishes = nil
        self.coordinate = nil
    }
    
    init(cafeteriaName: String?, dishes: [Dish]?, coordinate: CLLocationCoordinate2D?) {
        self.date = Date()
        self.configuration = ConfigurationIntent()
        self.cafeteriaName = cafeteriaName
        self.dishes = dishes
        self.coordinate = coordinate
    }
    
    static let mockEntry = CafeteriaWidgetEntry(
        cafeteriaName: "Some Cafeteria",
        dishes: Dish.mockDishes,
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 11)
    )
}

struct CafeteriaWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var entry: CafeteriaWidgetProvider.Entry

    var body: some View {
        if let name = entry.cafeteriaName, let coordinate = entry.coordinate {
            CafeteriaWidgetContent(
                size: WidgetSize.from(widgetFamily: widgetFamily),
                cafeteria: name,
                dishes: entry.dishes ?? [],
                coordinate: coordinate
            )
            .widgetBackground()
        } else {
            Text("There was an error fetching the widget content.")
        }
    }
}

struct CafeteriaWidget: Widget {
    let kind = "cafeteria-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: CafeteriaWidgetProvider()) { entry in
            CafeteriaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cafeteria Widget")
        .description("Displays the menu of the nearest cafeteria.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CafeteriaWidget_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaWidgetEntryView(entry: CafeteriaWidgetEntry.mockEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

