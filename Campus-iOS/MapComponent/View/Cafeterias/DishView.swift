//
//  DishView.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import SwiftUI

@MainActor
struct DishView: View {
    @StateObject var vm: DishViewModel = DishViewModel()
    @State private var isExpanded = false
    
    let dish: Dish
    let dishLabels: [String : DishLabel]
    
    init(dish: Dish, dishLabels: [String : DishLabel]) {
        self.dish = dish
        self.dishLabels = dishLabels
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            HStack{
                VStack{
                    ForEach(dish.labels, id: \.self) { label in
                        Text(vm.labelToAbbreviation(generalLabel: dishLabels, label: label))
                    }
                }
                .padding(.trailing, 10.0)
                VStack(alignment: .leading){
                    ForEach(dish.labels, id: \.self) { label in
                        Text(vm.labelToDescription(generalLabel: dishLabels, label: label))
                    }
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: 10){
                Spacer().frame(height: 0)
                Text(dish.name).bold()
                HStack{
                    Spacer()
                    Text(vm.formatPrice(dish: dish, pricingGroup: "students"))
                        .lineLimit(1)
                        .font(.system(size: 15))
                }
                Spacer().frame(height: 0)
            }
        }
        .buttonStyle(PlainButtonStyle()).disabled(true)
    }
}
