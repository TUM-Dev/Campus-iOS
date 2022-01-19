//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
<<<<<<< HEAD
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
=======
    @State var title: String
    @State var menu: Menu
    @State var categories: [Category] = []
    @State var dishes: [Dish] = []
    @State private var expanded: [Bool] = []

    var body: some View {
        List {
            ForEach(categories, id: \.self) { categoryItem in
                Section(categoryItem.name) {
                    ForEach(Array(categoryItem.dishes.enumerated()), id: \.1.self) { i, dish in
                        DisclosureGroup(isExpanded: $expanded[i]) {
                            HStack {
                                ForEach(dish.prices.keys.sorted(by: >), id: \.key) { k in
                                    VStack {
                                        Text(k)
                                        //Text(v)
                                    }
                                }
                            }
                        } label: {
                            Text(dish.name)
                                .onTapGesture {
                                    withAnimation {
                                        self.expanded[i].toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            setList()
        }
    }
    
    func setList() {
        let sortedCategories = menu.categories.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name > rhs.name
        })
                
        for var c in sortedCategories {
            for d in menu.dishes {
                if c.name == d.dishType {
                    expanded.append(false)
                    if !c.dishes.contains(d) {
                        c.dishes.append(d)
                        expanded.append(false)
                    }
                }
            }
            var newCat = Category(name: c.name, dishes: c.dishes)
            categories.append(newCat)
        }
>>>>>>> 899e34e (Full MealPlan & MenuViews)
    }
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menu: )
    }
}*/
