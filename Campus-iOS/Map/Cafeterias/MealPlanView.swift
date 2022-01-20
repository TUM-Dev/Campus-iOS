//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanView: View {
    @ObservedObject var viewModel: MealPlanViewModel
        
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.menus) { menu in
                    NavigationLink(destination: MenuView(viewModel: menu)) {
                        Text(menu.title)
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

/*struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView(canteen: .constant())
    }
}*/
