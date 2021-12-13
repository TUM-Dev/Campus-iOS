//
//  MensaMenuWidget.swift
//  MensaMenuWidget
//
//  Created by Nikolai Madlener on 02.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = ViewMensaLocationIntent

    func cafeteriaLocation(for config: ViewMensaLocationIntent) -> CafeteriaLocation {
        switch config.location {
        case .mensa_arcisstr:
            return .mensa_arcisstr
        case .mensa_garching:
            return .mensa_garching
        case .mensa_leopoldstr:
            return .mensa_leopoldstr
        case .mensa_lothstr:
            return .mensa_lothstr
        case .mensa_martinsried:
            return .mensa_martinsried
        case .mensa_pasing:
            return .mensa_pasing
        case .mensa_weihenstephan:
            return .mensa_weihenstephan
        default:
            return .mensa_arcisstr
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), cafeteriaLocation: CafeteriaLocation.mensa_arcisstr, menu: nil)
    }
    
    func getSnapshot(for configuration: ViewMensaLocationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let mensaApiKey = cafeteriaLocation(for: configuration).mensaApiKey()
            let menu = MensaService.shared.getMensaMenu(mensaApiKey: mensaApiKey)
            let entry = SimpleEntry(date: Date(), cafeteriaLocation: cafeteriaLocation(for: configuration), menu: menu)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ViewMensaLocationIntent, in context: Context, completion: @escaping (Timeline<Self.Entry>) -> ()) {
        Task {
            // Generate a timeline with one entry that refreshes at midnight
            let currentDate = Date()
            let startOfDay = Calendar.current.startOfDay(for: currentDate)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let mensaApiKey = cafeteriaLocation(for: configuration).mensaApiKey()
            let menu = MensaService.shared.getMensaMenu(mensaApiKey: mensaApiKey)
            let entry = SimpleEntry(date: Date(), cafeteriaLocation: cafeteriaLocation(for: configuration), menu: menu)
            let timeline = Timeline(entries: [entry], policy: .after(endOfDay)) // refreshes at midnight
            
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let cafeteriaLocation: CafeteriaLocation
    let menu: Menu?
}

struct MensaMenuWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    let date = Date()
    let dateFormatter = DateFormatter.EEEEddMMM
    
    var body: some View {
        VStack(spacing: 0) {
            VStack (spacing: 0){
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                    Text(entry.cafeteriaLocation.name())
                        .font(.caption)
                        .bold()
                    Spacer()
                    Text("\(dateFormatter.string(from: entry.date))")
                        .font(.caption)
                        .bold()
                }.padding(.leading, 25)
                    .padding(.trailing, 35)
                    .padding(.bottom, 5)
                ForEach(getDishes(sideDishes: false).prefix(family == .systemLarge ? 8 : 7), id: \.self) { dish in
                    HStack {
                        Text(foodEmojiProvider(ingredients: dish.ingredients, dishType: dish.dishType)).font(.system(size: 13))
                        Text(dish.name)
                            .lineLimit(1)
                            .font(.system(size: 14, weight: .semibold))
                        Text(ingredientsToString(ingredients: dish.ingredients))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.secondary)
                            .lineLimit(1)
                        Spacer()
                    }
                    Spacer().frame(minHeight: 0, maxHeight: 2)
                }.padding(.horizontal, 10)
                
                if getDishes(sideDishes: false).isEmpty {
                    Spacer()
                    Text("No dishes available today".localized)
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.secondary)
                }
                Spacer()
            }.padding(.vertical, 5)
                .background(Color("BackgroundTop"))
            
            if family == .systemLarge {
                VStack(spacing: 0) {
                    HStack {
                        Text("SIDE DISHES".localized).font(.caption).bold().foregroundColor(Color.secondary).padding(.horizontal, 15)
                        Spacer()
                    }.padding(.vertical, 5)
                    VStack {
                        ForEach(getDishes(sideDishes: false).prefix(8), id: \.self) { dish in
                            HStack {
                                Text(dish.name)
                                    .lineLimit(1)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(ingredientsToString(ingredients: dish.ingredients))
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color.secondary)
                                    .lineLimit(1)
                                Spacer()
                            }
                            Spacer().frame(minHeight: 0, maxHeight: 2)
                        }
                    }.padding(.horizontal, 15)
                    if getDishes(sideDishes: false).isEmpty {
                        Spacer()
                        Text("No dishes available today".localized)
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color.secondary)
                    }
                    Spacer()
                }.background(Color("BackgroundBottom"))
            }
        }
    }
    
    func getDishes(sideDishes: Bool) -> [Dish] {
        entry.menu?.dishes.filter({ sideDishes ? $0.dishType == "Beilagen" : $0.dishType != "Beilagen"}) ?? []
    }
    
    func ingredientsToString(ingredients: [String]) -> String {
        let string = ingredients.joined(separator:",")
        if string != "" {
            return "(" + string + ")"
        }
        return ""
    }
    
    func foodEmojiProvider(ingredients: [String], dishType: String) -> String {
        if ingredients.contains("f") {
            return "🥕"
        } else if ingredients.contains("v") {
            return "🫑"
        } else if ingredients.contains("S") {
            return "🐷"
        } else if ingredients.contains("R") {
            return "🥩"
        } else if ingredients.contains("W") {
            return "🦌"
        } else if ingredients.contains("L") {
            return "🐑"
        } else if ingredients.contains("Fi") {
            return "🐟"
        } else if !ingredients.contains("Ei") && !ingredients.contains("Mi") && dishType != "Fleisch" && dishType != "Fisch" && dishType != "Grill" { //vegan (without v tag)
            return "🫑"
        } else if !ingredients.contains("14") && dishType != "Fleisch" && dishType != "Fisch" && dishType != "Grill" { //vegertarian (without f tag)
            return "🥕"
        } else {
            return "❓"
        }
    }
}

@main
struct MensaMenuWidget: Widget {
    let kind: String = "MensaMenuWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ViewMensaLocationIntent.self, provider: Provider()) { entry in
            MensaMenuWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cafeteria".localized)
        .description("Cafeteria menu at a glance".localized)
        .supportedFamilies([.systemLarge, .systemMedium])
    }
}

struct MensaMenuWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) {
                return MensaMenuWidgetEntryView(entry: SimpleEntry(date: Date(), cafeteriaLocation: CafeteriaLocation.mensa_arcisstr, menu: MockMenu.shared.getMockedMenu()))
                    .previewContext(WidgetPreviewContext(family: .systemLarge)).preferredColorScheme($0)
            }
            ForEach(ColorScheme.allCases, id: \.self) {
                return MensaMenuWidgetEntryView(entry: SimpleEntry(date: Date(), cafeteriaLocation: CafeteriaLocation.mensa_arcisstr, menu: MockMenu.shared.getMockedMenu()))
                    .previewContext(WidgetPreviewContext(family: .systemMedium)).preferredColorScheme($0)
                
            }
        }
    }
}
