//
//  MealPlanScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import SwiftUI

struct MealPlanScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: MealPlanViewModel
    
    init(cafeteria: Cafeteria) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel(cafeteria: cafeteria))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let menus):
                if let firstMenu = menus.first {
                    VStack {
                        MealPlanView(menus: menus, cafeteria: vm.cafeteria, selectedMenu: firstMenu).refreshable {
                            await vm.getMenus()
                        }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Menus")
            case .failed(_):
                VStack {
                    Spacer()
                    // Since some cafeterias do not update their menus this is how we handle error here. There could be a better differentiation.
                    Text("No Menu available").foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
                    Spacer()
                }
            }
        }.task {
            await vm.getMenus()
        }
    }
}
