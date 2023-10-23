//
//  CafeteriaViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 29.04.23.
//

import SwiftUI

struct CafeteriaView: View {
    
    @StateObject var vm: MealPlanViewModel
    let cafeteria: Cafeteria
    @State var isExpanded = false
    @State private var rotationAngle: Double = 0
    let onlyMenu: Bool
    let isListItem: Bool
    
    init(cafeteria: Cafeteria) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel(cafeteria: cafeteria))
        self.cafeteria = cafeteria
        self.onlyMenu = false
        self.isListItem = false
    }
    
    init(cafeteria: Cafeteria, onlyMenu: Bool) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel(cafeteria: cafeteria))
        self.cafeteria = cafeteria
        self.onlyMenu = onlyMenu
        self.isListItem = false
    }
    
    init(cafeteria: Cafeteria, isListItem: Bool) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel(cafeteria: cafeteria))
        self.cafeteria = cafeteria
        self.onlyMenu = false
        self.isListItem = isListItem
    }
    
    var body: some View {
        VStack {
            if onlyMenu {
                Text("Menu").titleStyle()
            } else {
                HStack {
                    VStack (alignment: .leading) {
                        Text(cafeteria.name).font(.headline.bold())
                            .padding(.bottom, 2)
                        NavigationLink(destination: LocationView(location: TUMLocation(cafeteria: self.cafeteria))) {
                            Label("View Location", systemImage: "mappin.circle")
                                .font(.footnote)
                                .foregroundColor(.highlightText)
                        }
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                            rotationAngle = isExpanded ? 90 : 0
                        }
                    } label: {
                        HStack {
                            Text("Menu")
                            Image(systemName: "chevron.right")
                                .frame(width: 20)
                                .rotationEffect(Angle(degrees: rotationAngle))
                        }
                        .padding(5)
                        .foregroundColor(.primaryText)
                    }
                }.padding(.horizontal)
            }
            
            //only menu always shows the expanded view without the title of the cafetera
            if isExpanded || onlyMenu {
                Group {
                    switch vm.state {
                    case .success(let menus):
                        if let firstMenu = menus.first {
                            MenuWeekView(menus: menus, selectedMenu: firstMenu, isListItem: isListItem)
                        }
                    case .loading, .na:
                        LoadingView(text: "Fetching Menus")
                    case .failed(_):
                        VStack {
                            Spacer()
                            // Since some cafeterias do not update their menus this is how we handle error here. There could be a better differentiation.
                            Text("No Menu available")
                            Spacer()
                        }
                    }
                }.task {
                    await vm.getMenus()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
        .padding(.bottom, 10)
    }
}

