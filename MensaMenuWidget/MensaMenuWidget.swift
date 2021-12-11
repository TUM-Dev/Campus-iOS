//
//  MensaMenuWidget.swift
//  MensaMenuWidget
//
//  Created by Nikolai Madlener on 02.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation
import Alamofire

struct Provider: IntentTimelineProvider {
    
    typealias Entry = SimpleEntry
    typealias Intent = ViewMensaLocationIntent
    
    private let sessionManager = Session.default
    
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
            let menu = try await MensaService.shared.getMensaMenu(mensaApiKey: mensaApiKey)
            let entry = SimpleEntry(date: Date(), cafeteriaLocation: cafeteriaLocation(for: configuration), menu: menu)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ViewMensaLocationIntent, in context: Context, completion: @escaping (Timeline<Self.Entry>) -> ()) {
        Task {
            do {
                let mensaApiKey = cafeteriaLocation(for: configuration).mensaApiKey()
                let menu = try await MensaService.shared.getMensaMenu(mensaApiKey: mensaApiKey)
                let entry = SimpleEntry(date: Date(), cafeteriaLocation: cafeteriaLocation(for: configuration), menu: menu)
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60 * 8))) // 8 hrs
                
                completion(timeline)
            } catch {
                print(error)
            }
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
    let dateFormatter = DateFormatter()
    
    var body: some View {
        dateFormatter.dateFormat = "EEEE, dd. MMM"
        
        return VStack(spacing: 0) {
            VStack (spacing: 0){
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                    Text(entry.cafeteriaLocation.name()).font(.caption).bold()
                    Spacer()
                    Text("\(dateFormatter.string(from: entry.date))").font(.caption).bold()
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
        } else if !ingredients.contains("Ei") && !ingredients.contains("Mi") && dishType != "Fleisch" && dishType != "Fisch" { //vegan (without v tag)
            return "🫑"
        } else if !ingredients.contains("14") && dishType != "Fleisch" && dishType != "Fisch" { //vegertarian (without f tag)
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

final class MensaService {
    static let shared = MensaService()
    //    let thisWeekEndpoint = EatAPI.menu(location: "mensa-garching", year: Date().year, week: Date().weekOfYear).asURLRequest()
    
    private init() {}
    public func getMensaMenu(mensaApiKey: String) async throws -> Menu? {
        let url = URL(string: "https://tum-dev.github.io/eat-api/" + "\(mensaApiKey)/\(Date().year)/\(Date().weekOfYear).json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        //        let sessionManager = Session.default
        //        let thisWeekEndpoint = EatAPI.menu(location: "mensa-garching", year: Date().year, week: Date().weekOfYear)
        //        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [weak self] response in
        //            print("response:")
        //            print(response)
        //            guard let value = response.value else { return }
        //            menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
        //            menus.sort(by: <)
        //        }
        
        do {
            let mealPlan = try decoder.decode(MealPlan.self, from: data)
            return mealPlan.days.first(where: {
                !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false)
            })
        } catch {
            print(error)
        }
        return nil
    }
}


public enum CafeteriaLocation: String {
    case mensa_arcisstr
    case mensa_garching
    case mensa_leopoldstr
    case mensa_lothstr
    case mensa_martinsried
    case mensa_pasing
    case mensa_weihenstephan
    
    func mensaApiKey() -> String {
        switch self {
        case .mensa_arcisstr:
            return "mensa-arcisstr"
        case .mensa_garching:
            return "mensa-garching"
        case .mensa_leopoldstr:
            return "mensa-leopoldstr"
        case .mensa_lothstr:
            return "mensa-lothstr"
        case .mensa_martinsried:
            return "mensa-martinsried"
        case .mensa_pasing:
            return "mensa-pasing"
        case .mensa_weihenstephan:
            return "mensa_weihenstephan"
        }
    }
    
    func name() -> String {
        switch self {
        case .mensa_arcisstr:
            return "Mensa Arcisstraße"
        case .mensa_garching:
            return "Mensa Garching"
        case .mensa_leopoldstr:
            return "Mensa Leopoldstraße"
        case .mensa_lothstr:
            return "Mensa Lothstraße"
        case .mensa_martinsried:
            return "Mensa Martinsried"
        case .mensa_pasing:
            return "Mensa Pasing"
        case .mensa_weihenstephan:
            return "Mensa Weihenstephan"
        }
    }
    
}
