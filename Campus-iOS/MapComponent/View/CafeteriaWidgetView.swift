//
//  CafeteriaWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit

struct CafeteriaWidgetView: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel
    
    var body: some View {
        
        VStack {
            switch(viewModel.status) {
            case .error:
                Text("No nearby cafeteria.")
            case .loading:
                Text("Searching nearby cafeteria")
                ProgressView()
            default:
                
                if let cafeteria = viewModel.cafeteria {
                    Text(cafeteria.title ?? "Unknown cafeteria")
                        .bold()
                }
                
                Spacer()
                
                if viewModel.status != .noMenu, let menuVm = viewModel.menuViewModel {
                    CompactMenuView(viewModel: menuVm)
                } else {
                    Text("No menu for today.")
                }
                
                Spacer()
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct CompactMenuView: View {
    
    @ObservedObject var viewModel: MenuViewModel
    @State private var dishIndex = 0
    private var dishes: [Dish] = []
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        for category in viewModel.categories {
            for dish in category.dishes {
                dishes.append(dish)
            }
        }
    }
    
    var body: some View {
        
        if !dishes.isEmpty {
            
            CompactDishView(dish: dishes[dishIndex])
                .onReceive(self.timer) { _ in
                    withAnimation {
                        dishIndex = (dishIndex + 1) % dishes.count
                    }
                }
            
        } else {
            Text("No dishes.")
        }
    }
}

struct CompactDishView: View {
    
    var dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dish.name)
                    .lineLimit(1)
                Spacer()
                Text(DishView.formatPrice(dish: dish, pricingGroup: "students"))
            }
            
            Spacer()
            
            Text("Allergenics")
                .bold()
            
            Text(
                dish.labels
                    .map({ DishView.labelToAbbreviation(label: $0 )})
                    .joined(separator: " ")
            )
            .lineLimit(1)
        }
    }
}

struct CafeteriaWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaWidgetView(viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService()))
        CafeteriaWidgetView(viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService()))
            .preferredColorScheme(.dark)
    }
}
