//
//  CafeteriaWidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 08.02.23.
//

import SwiftUI

struct CafeteriaWidgetScreen: View {
    
    @StateObject var cafeteriaWidgetVM : CafeteriaWidgetViewModel
    
    var body: some View {
        Group {
            switch(self.cafeteriaWidgetVM.status) {
            case .error:
                TextWidgetView(text: "No nearby cafeteria.")
            case .loading:
                WidgetLoadingView(text: "Searching nearby cafeteria")
            case .noMenu:
                EmptyView().onAppear {
                    print("No Cafeteria Menu available!")
                }
            case .success:
                CafeteriaWidget2(cafeteriaWidgetVM: self.cafeteriaWidgetVM, dishes: self.cafeteriaWidgetVM.menuViewModel?.getDishes() ?? [])
            }
        }
    }
}
