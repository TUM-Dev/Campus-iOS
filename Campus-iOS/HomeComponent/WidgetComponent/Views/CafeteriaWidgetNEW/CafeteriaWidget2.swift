//
//  CafeteriaWidget2.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 15.02.23.
//

import SwiftUI

struct CafeteriaWidget2: View {
    
    @StateObject var cafeteriaWidgetVM : CafeteriaWidgetViewModel
    
    var body: some View {
        if let cafeteria = self.cafeteriaWidgetVM.cafeteria {
            VStack {
                Text("\(Image(systemName: "fork.knife")) \(cafeteria.name)").titleStyle()
                if let menus = self.cafeteriaWidgetVM.mealPlanViewModel?.menus {
                    
                }
            }
        }
    }
}

