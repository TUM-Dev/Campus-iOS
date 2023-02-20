//
//  CafeteriaWidget2.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 15.02.23.
//

import SwiftUI

struct CafeteriaWidget2: View {
    
    @StateObject var cafeteriaWidgetVM : CafeteriaWidgetViewModel
    var dishes : [Dish]
    
    
    
    var body: some View {
        if let cafeteria = self.cafeteriaWidgetVM.cafeteria {
            VStack(spacing: 0) {
                Text(cafeteria.name).titleStyle()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(dishes, id: \.id ) { dish in
                            VStack(alignment: .leading){
                                HStack{
                                    Text(getTypeLabel(dishType: dish.dishType))
                                    Spacer()
                                    MealIngredientsView(mealTitle: dish.name, labels: getIngredientLabels(ingredientLabels: dish.labels), price: DishView.formatPrice(dish: dish, pricingGroup: "students"))
                                }
                                Text(dish.name + "\n")
                                    .lineLimit(3)
                                    .padding(.vertical, 5)
                                Text(DishView.formatPrice(dish: dish, pricingGroup: "students"))
                                    .lineLimit(1)
                            }
                            .frame(width: 150)
                            .padding()
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                        }
                    }
                    .padding(.horizontal)
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
    
    func getIngredientLabels(ingredientLabels: [String]) -> [String] {
        var result = [String]()
        for label in ingredientLabels {
            let newLabel = "\(labelToAbbreviation(label: label)) \(labelToDescription(label: label))"
            result.append(newLabel)
        }
        return result
    }
    
    func labelToAbbreviation(label: String) -> String {
        let labelLookup = MensaEnumService.shared.getLabels()
        
        if let labelObject = labelLookup[label] {
            return labelObject.abbreviation
        }
        return label
    }
    
    func labelToDescription(label: String) -> String {
        let labelLookup = MensaEnumService.shared.getLabels()
        
        if Locale.current.languageCode == "de"{
            if let labelObject = labelLookup[label], let text = labelObject.text["DE"] {
                return text
            }
        } else {
            if let labelObject = labelLookup[label], let text = labelObject.text["EN"] {
                return text
            }
        }
        
        return label
    }
    
}

