//
//  CafeteriaWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit

struct CafeteriaWidgetView: View {
    
    let size: WidgetSize
    
    init(size: WidgetSize = .square) {
        self.size = size
    }
    
    var body: some View {
        WidgetFrameView(
            size: size,
            content: CafeteriaWidgetContent(size: size)
        )
    }
}

struct CafeteriaWidgetContent: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    let size: WidgetSize
    
    var body: some View {
        VStack(alignment: .leading) {
            switch(viewModel.status) {
            case .error:
                Text("No nearby cafeteria.")
            case .loading:
                Text("Searching nearby cafeteria")
                ProgressView()
            default:
                
                if let cafeteria = viewModel.cafeteria {
                    WidgetTitleView(title: cafeteria.title ?? "Unknown cafeteria")
                        .padding(.bottom, 2)
                }
                
                if viewModel.status != .noMenu, let menuVm = viewModel.menuViewModel {
                    CompactMenuView(viewModel: menuVm, size: size)
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
    let size: WidgetSize
    
    private var dishes: [Dish] = []
    private var displayedDishes: Int
    
    init(viewModel: MenuViewModel, size: WidgetSize) {
        self.viewModel = viewModel
        self.size = size
        
        for category in viewModel.categories {
            for dish in category.dishes {
                dishes.append(dish)
            }
        }
        
        switch (size) {
        case .square, .rectangle:
            displayedDishes = 1
        case .bigSquare:
            displayedDishes = 5
        }
    }
    
    var body: some View {
        
        if !dishes.isEmpty {
            VStack(alignment: .leading) {
                ForEach(dishes.prefix(displayedDishes), id: \.self) { dish in
                    CompactDishView(dish: dish)
                        .padding(.bottom, 2)
                }
                
                Spacer()
                
                let remainingDishes = dishes.count - displayedDishes
                if (remainingDishes > 1) {
                    Text("+ \(remainingDishes) more dishes")
                        .foregroundColor(.green)
                        .bold()
                } else if (remainingDishes == 1) {
                    Text("+ 1 more dish")
                        .foregroundColor(.green)
                        .bold()
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
            Text(dish.name)
                .lineLimit(1)
            Text(DishView.formatPrice(dish: dish, pricingGroup: "students"))
                .font(.caption)
                .bold()
        }
        .frame(alignment: .leading)
    }
}

struct CafeteriaWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaWidgetView()
        CafeteriaWidgetView()
            .preferredColorScheme(.dark)
    }
}
