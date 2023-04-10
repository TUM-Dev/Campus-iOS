//
//  DishViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import Foundation

@MainActor
class DishViewModel: ObservableObject {
    @Published var state: APIState<[String: DishLabel]> = .na
    
    let service = DishService()
    let dish: Dish
    
    init(dish: Dish) {
        self.dish = dish
    }
    
    func getDishLabels(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        
        let dishLabels = await service.fetch(forcedRefresh: forcedRefresh)
        if let generalLabels = dishLabels {
            self.state = .success(
                data: generalLabels
            )
        } else {
            self.state = .success(data: [:])
        }
    }
    
    func formatPrice(dish: Dish, pricingGroup: String) -> String {
        let priceFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.currencySymbol = "€"
                formatter.numberStyle = .currency
                return formatter
            }()
        
        let price: Price
        
        var basePriceString: String?
        var unitPriceString: String?
        
        switch pricingGroup {
        case "staff":
            price = dish.prices["staff"]!
        case "guests":
            price = dish.prices["guests"]!
        default:
            price = dish.prices["students"]!
        }
        
        if let basePrice = price.basePrice, basePrice != 0 {
            basePriceString = priceFormatter.string(for: basePrice)
        }

        if let unitPrice = price.unitPrice, let unit = price.unit, unitPrice != 0 {
            unitPriceString = priceFormatter.string(for: unitPrice)?.appending(" / " + unit)
        }

        let divider: String = !(basePriceString?.isEmpty ?? true) && !(unitPriceString?.isEmpty ?? true) ? " + " : ""
        
        let finalPrice: String = (basePriceString ?? "") + divider + (unitPriceString ?? "")
        
        return finalPrice
    }
    
    func labelToAbbreviation(generalLabel: [String:DishLabel]?, label: String) -> String {
        if let labelObject = generalLabel?[label] {
            return labelObject.abbreviation
        }
        return label
    }
    
    func labelToDescription(generalLabel: [String:DishLabel]?, label: String) -> String {
        if let labelObject = generalLabel?[label], let text = labelObject.text["DE"] {
            return text
        }
        return label
    }
    
    func labelsToString(generalLabel: [String:DishLabel]?, labels: [String]) -> String {
        let shortenedLabels = labels.map{label -> String in
            return labelToAbbreviation(generalLabel: generalLabel, label: label)
        }
        return shortenedLabels.joined(separator:", ")
    }
}
