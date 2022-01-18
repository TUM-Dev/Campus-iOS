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
    @State var dishNames: [String] = []
    
    var body: some View {
        List {
            ForEach(categories, id: \.self) { categoryItem in
                Section(categoryItem.name) {
                    ForEach(categoryItem.dishes, id: \.self) { dish in
                        Text(dish.name)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.black)
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
                    if !c.dishes.contains(d) {
                        c.dishes.append(d)
                    }
                }
            }
            var newCat = Category()
            newCat.name = c.name
            newCat.dishes = c.dishes
            categories.append(newCat)
        }
    }
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menu: )
    }
}*/
