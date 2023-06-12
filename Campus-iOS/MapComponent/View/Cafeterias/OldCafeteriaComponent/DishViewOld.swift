//
//  DishView.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import SwiftUI

struct DishViewOld: View {
    @StateObject var vm: DishViewModel
    @State private var isExpanded = false
    
    init(dish: Dish) {
        self._vm = StateObject(wrappedValue: DishViewModel(dish: dish))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(data: let generalLabels):
                DisclosureGroup(isExpanded: $isExpanded) {
                    HStack{
                        VStack{
                            ForEach(vm.dish.labels, id: \.self) { label in
                                Text(vm.labelToAbbreviation(generalLabel: generalLabels, label: label))
                            }
                        }
                        .padding(.trailing, 10.0)
                        VStack(alignment: .leading){
                            ForEach(vm.dish.labels, id: \.self) { label in
                                Text(vm.labelToDescription(generalLabel: generalLabels, label: label))
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 10){
                        Spacer().frame(height: 0)
                        Text(vm.dish.name).bold()
                        HStack{
                            Spacer()
                            Text(vm.formatPrice(dish: vm.dish, pricingGroup: "students"))
                                .lineLimit(1)
                                .font(.system(size: 15))
                        }
                        Spacer().frame(height: 0)
                    }
                }
                .buttonStyle(PlainButtonStyle()).disabled(true)
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
