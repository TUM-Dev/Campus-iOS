//
//  CafeteriaWidget.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 15.02.23.
//

import SwiftUI

struct CafeteriaWidget: View {
    
    @StateObject var cafeteriaWidgetVM : CafeteriaWidgetViewModel
    var dishes : [Dish]
    
    init(cafeteriaWidgetVM: CafeteriaWidgetViewModel, dishes: [Dish]) {
        self._cafeteriaWidgetVM = StateObject(wrappedValue: cafeteriaWidgetVM)
        self.dishes = dishes
        self.dishes = dishes.sorted(by: { getTypeLabel(dishType: $0.dishType) > getTypeLabel(dishType: $1.dishType)})
    }
    
    var body: some View {
        if let cafeteria = self.cafeteriaWidgetVM.cafeteria {
            VStack(spacing: 0) {
                Text("Nearest cafeteria").titleStyle()
                HStack {
                    Text(cafeteria.name).font(.headline.bold())
                        .padding(.bottom, 2)
                    Spacer()
                    NavigationLink(destination: LocationView(location: TUMLocation(cafeteria: cafeteria))) {
                        Label("View Location", systemImage: "mappin.circle")
                            .font(.footnote)
                            .foregroundColor(.highlightText)
                    }
                    
                    
                }.padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(dishes, id: \.id ) { dish in
                            DishView(dish: dish)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    func getTypeLabel(dishType: String) -> String {
        switch dishType {
        case "Wok":
            return "🥘"
        case "Pasta":
            return "🍝"
        case "Pizza":
            return "🍕"
        case "Fleisch":
            return "🥩"
        case "Grill":
            return "🍖"
        case "Studitopf":
            return "🍲"
        case "Vegetarisch/fleischlos":
            return "🥗"
        case "Fisch":
            return "🐟"
        case "Suppe":
            return "🍜"
        default:
            return " "
        }
    }
}

