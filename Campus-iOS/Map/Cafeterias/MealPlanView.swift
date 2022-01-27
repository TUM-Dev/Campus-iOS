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
    
    let formatter = DateFormatter()
        
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.menus) { menu in
                    let title = formatter.string(from: menu.date)
                    NavigationLink(destination: MenuView(viewModel: menu, title: title)) {
                        Text(formatter.string(from: menu.date))
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .onAppear {
                formatter.dateFormat = "EEEE, dd.MM.yyyy"
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
