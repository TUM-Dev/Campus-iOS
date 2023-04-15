//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
    let menu: cafeteriaMenu
    
    var body: some View {
        List {
            ForEach(menu.categories.sorted { $0.name < $1.name }) { category in
                Section(category.name) {
                    ForEach(category.dishes, id: \.self) { dish in
                        DishView(dish: dish)
                    }
                }
            }
        }.listStyle(GroupedListStyle()) // make sections non-collapsible
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView(viewModel: MenuViewModel(date: Date(), categories: []))
//    }
//}
