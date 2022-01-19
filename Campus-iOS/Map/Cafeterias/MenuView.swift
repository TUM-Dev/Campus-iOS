//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
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
    }
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menu: )
    }
}*/
