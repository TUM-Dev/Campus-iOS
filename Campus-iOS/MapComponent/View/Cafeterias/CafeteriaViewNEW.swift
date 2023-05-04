//
//  CafeteriaViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 29.04.23.
//

import SwiftUI

struct CafeteriaViewNEW: View {
    
    @StateObject var vm: MealPlanViewModel
    let cafeteria: Cafeteria
    @State var isExpanded = false
    @State private var rotationAngle: Double = 0
    
    init(cafeteria: Cafeteria) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel(cafeteria: cafeteria))
        self.cafeteria = cafeteria
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading) {
                    Text(cafeteria.name).font(.headline.bold())
                        .padding(.bottom, 2)
                    Button() {
                        print("Button tapped!")
                    } label: {
                        Label("View Location", systemImage: "arrow.up.forward.app")
                    }
                    .font(.footnote)
                    .foregroundColor(.highlightText)
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
                    .background(Color.secondaryBackground)
                    .cornerRadius(5)
                }
            }.padding(.horizontal)
            
            if isExpanded {
                Group {
                    switch vm.state {
                    case .success(let menus):
                        if let firstMenu = menus.first {
                            MenuWeekView(menus: menus, selectedMenu: firstMenu)
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
