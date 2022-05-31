//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel
    
    var body: some View {
        List {
            ForEach($viewModel.categories) { $category in
                Section(category.name) {
                    ForEach(category.dishes, id: \.self) { dish in
                        DishView(dish: dish)
                    }
                }
            }
        }.listStyle(GroupedListStyle()) // make sections non-collapsible
    }
}

struct DishView: View {
    @State var dish: Dish
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            HStack{
                VStack{
                    ForEach(dish.labels, id: \.self){label in
                        Text(labelToAbbreviation(label: label))
                    }
                }
                .padding(.trailing, 10.0)
                VStack(alignment: .leading){
                    ForEach(dish.labels, id: \.self){label in
                        Text(labelToDescription(label: label))
                    }
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: 10){
                Spacer().frame(height: 0)
                Text(dish.name).bold()
                HStack{
                    Spacer()
                    Text(formatPrice(dish: dish, pricingGroup: "students"))
                        .lineLimit(1)
                        .font(.system(size: 15))
                }
                Spacer().frame(height: 0)
            }
        }
        .buttonStyle(PlainButtonStyle()).disabled(true)
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
    
    func labelToAbbreviation(label: String) -> String {
        let labelLookup = MensaEnumService.shared.getLabels()
        
        if let labelObject = labelLookup[label] {
            return labelObject.abbreviation
        }
        return label
    }
    
    func labelToDescription(label: String) -> String {
        let labelLookup = MensaEnumService.shared.getLabels()
        
        if let labelObject = labelLookup[label], let text = labelObject.text["DE"] {
            return text
        }
        return label
    }
    
    func labelsToString(labels: [String]) -> String {
        let shortenedLabels = labels.map{label -> String in
            return labelToAbbreviation(label: label)
        }
        return shortenedLabels.joined(separator:", ")
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(viewModel: MenuViewModel(date: Date(), categories: []))
    }
}
