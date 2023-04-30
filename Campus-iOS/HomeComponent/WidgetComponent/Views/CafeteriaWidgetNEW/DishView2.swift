//
//  DishView2.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 14.04.23.
//

import SwiftUI

import SwiftUI

struct DishView2: View {
    @StateObject var vm: DishViewModel
    
    init(dish: Dish) {
        self._vm = StateObject(wrappedValue: DishViewModel(dish: dish))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(data: let generalLabels):
                VStack(alignment: .leading){
                    HStack{
                        Text(vm.getTypeLabel(dishType: vm.dish.dishType))
                        Spacer()
                        MealIngredientsView(mealTitle: vm.dish.name, labels: vm.getIngredientLabels(generalLabel: generalLabels, ingredientLabels: vm.dish.labels), price: vm.formatPrice(dish: vm.dish, pricingGroup: "students"))
                    }
                    Text(vm.dish.name)
                        .lineLimit(2, reservesSpace: true)
                        .padding(.vertical, 5)
                    Text(vm.formatPrice(dish: vm.dish, pricingGroup: "students"))
                        .lineLimit(1)
                }
                .frame(width: 150)
                .padding()
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
            case .loading, .na:
                LoadingView(text: "Fetching Dish Labels")
            case .failed(error: let error):
                FailedView(errorDescription: error.localizedDescription, retryClosure: vm.getDishLabels
                )
            }
        }.task {
            await vm.getDishLabels()
        }
    }
}
