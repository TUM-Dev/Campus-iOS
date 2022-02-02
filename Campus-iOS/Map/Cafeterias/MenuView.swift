//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel
    @State var title: String
    
    var body: some View {
        List {
            ForEach($viewModel.categories) { $category in
                Section(category.name) {
                    DisclosureGroup(isExpanded: $category.isExpanded) {
                        ForEach(category.dishes, id: \.self) { dish in
                            ForEach(Array(dish.prices.keys).sorted(by: >), id: \.self) { key in
                                HStack {
                                    Text(key)
                                    Spacer()
                                    Text(self.configureDropDown(dish: dish, key: key))
                                }
                            }
                        }
                    } label: {
                        ForEach(category.dishes, id: \.self) { dish in
                            Text(dish.name)
                                .onTapGesture {
                                    withAnimation {
                                        category.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }
    
    func configureDropDown(dish: Dish, key: String) -> String {
        let priceFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.currencySymbol = "€"
                formatter.numberStyle = .currency
                return formatter
            }()
        
        let price: Price
        
        var basePriceString: String?
        var unitPriceString: String?
        
        switch key {
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
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menu: )
    }
}*/
