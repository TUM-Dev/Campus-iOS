//
//  CafeteriaWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit

struct CafeteriaWidgetView: View {
    
    @StateObject var viewModel: CafeteriaWidgetViewModel = CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
    
    @State private var size: WidgetSize
    private let initialSize: WidgetSize
    @State private var showDetails = false
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    init(size: WidgetSize, refresh: Binding<Bool> = .constant(false)) {
        self._size = State(initialValue: size)
        self.initialSize = size
        self._refresh = refresh
    }
    
    var content: some View {
        Group {
            switch(viewModel.status) {
            case .error:
                TextWidgetView(text: "No nearby cafeteria.")
            case .loading:
                WidgetLoadingView(text: "Searching nearby cafeteria")
            default:
                if let cafeteria = viewModel.cafeteria,
                   let title = cafeteria.title,
                   let coordinate = cafeteria.coordinate {
                    CafeteriaWidgetContent(
                        size: size,
                        cafeteria: title,
                        dishes: viewModel.menuViewModel?.getDishes() ?? [],
                        coordinate: coordinate
                    )
                    .background {
                        WidgetMapBackgroundView(coordinate: coordinate, size: size)
                    }
                } else {
                    TextWidgetView(text: "There was an error getting the menu from the nearest cafeteria.")
                }
            }
        }
        .onChange(of: refresh) { _ in
            if showDetails { return }
            Task { await viewModel.fetch() }
        }
        .task {
            await viewModel.fetch()
        }
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
            .onTapGesture {
                showDetails.toggle()
            }
            .sheet(isPresented: $showDetails) {
                VStack {
                    if let cafeteria = viewModel.cafeteria, let mealVm = viewModel.mealPlanViewModel {
                        CafeteriaView(
                            vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                            selectedCanteen: .constant(cafeteria),
                            canDismiss: false
                        )
                        MealPlanView(viewModel: mealVm)
                    } else {
                        ProgressView()
                    }
                }
            }
            .expandable(size: $size, initialSize: initialSize, scale: $scale)
    }
}

struct CafeteriaWidgetContent: View {
    
    let size: WidgetSize
    let cafeteria: String
    let dishes: [Dish]
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "fork.knife")
                Text(cafeteria)
                    .bold()
                    .lineLimit(2)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 2)
            
            CompactMenuView(size: size, dishes: dishes)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct CompactMenuView: View {
    
    let size: WidgetSize
    let dishes: [Dish]
    
    private var displayedDishes: Int
    
    init(size: WidgetSize, dishes: [Dish]) {
        
        self.size = size
        self.dishes = dishes
        
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
    
    struct cafeteriaWidgetContent: View {
        
        let size: WidgetSize
        
        var body: some View {
            CafeteriaWidgetContent(
                size: size,
                cafeteria: "Mensa Straubing",
                dishes: Dish.mockDishes,
                coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42)
            )
            .widgetBackground()
        }
    }
    
    static var content: some View {
        VStack {
            HStack {
                WidgetFrameView(
                    size: .square,
                    content: cafeteriaWidgetContent(size: .square)
                )
                
                WidgetFrameView(
                    size: .square,
                    content: cafeteriaWidgetContent(size: .square)
                )
            }
            
            WidgetFrameView(
                size: .rectangle,
                content: cafeteriaWidgetContent(size: .rectangle)
            )
            
            WidgetFrameView(
                size: .bigSquare,
                content: cafeteriaWidgetContent(size: .bigSquare)
            )
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
