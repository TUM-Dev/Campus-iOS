//
//  MenuView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 15.01.22.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        List {
            ForEach($viewModel.categories) { $category in
                Section(category.name) {
                    DisclosureGroup(isExpanded: $category.isExpanded) {
                        Text("todo")
                    } label: {
                        ForEach(category.dishes, id: \.self) { dish in
                            Text(dish.name)
                                .onTapGesture {
                                    withAnimation {
                                        category.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menu: )
    }
}*/
