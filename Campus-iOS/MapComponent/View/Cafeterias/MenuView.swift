//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

class MenuViewModel: ObservableObject {
    @Published var state: APIState<[String: DishLabel]> = .na
    
    let service = DishService()
    
    func getDishLabels(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        
        let dishLabels = await service.fetch(forcedRefresh: forcedRefresh)
        if let generalLabels = dishLabels {
            self.state = .success(
                data: generalLabels
            )
        } else {
            self.state = .success(data: [:])
        }
    }
}

struct MenuScreen: View {
    @StateObject var vm: MenuViewModel = MenuViewModel()
    let menu: Menu
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let dishLabels):
                MenuView(menu: menu, dishLabels: dishLabels)
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
            await vm.getDishLabels()
        }
    }
}

struct MenuView: View {
    let menu: Menu
    let dishLabels: [String : DishLabel]
    
    var body: some View {
        List {
            ForEach(menu.categories.sorted { $0.name < $1.name }) { category in
                Section(category.name) {
                    ForEach(category.dishes, id: \.self) { dish in
                        DishView(dish: dish, dishLabels: dishLabels)
                    }
                }
            }
        }.listStyle(GroupedListStyle()) // make sections non-collapsible
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView(viewModel: MenuViewModel(date: Date(), categories: []))
//    }
//}
