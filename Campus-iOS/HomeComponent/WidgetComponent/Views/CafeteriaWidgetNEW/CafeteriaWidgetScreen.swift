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
                TextWidgetView(text: "No menu")
            case .success:
                VStack {
                    CafeteriaWidgetViewNEW(cafeteriaWidgetVM: self.cafeteriaWidgetVM)
                        .padding(.bottom, 10)
                    CafeteriaWidget2(cafeteriaWidgetVM: self.cafeteriaWidgetVM)
                }
            }
        }
    }
}
