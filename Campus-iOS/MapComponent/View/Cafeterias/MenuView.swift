//
//  MenuViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.04.23.
//

import SwiftUI

struct MenuView: View { //wird grad ned genutzt evtl delete
    
    let menu: cafeteriaMenu
    
    var body: some View {
        VStack{
            ForEach(menu.categories.sorted { $0.name < $1.name }) { category in
                Text(category.name)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(category.dishes, id: \.self) { dish in
                            DishView2(dish: dish)
                        }
                    }.padding(.horizontal)
                }
            }
        }
    }
}
