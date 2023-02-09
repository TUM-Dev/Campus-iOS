//
//  CafeteriaWidgetViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 08.02.23.
//

import SwiftUI

struct CafeteriaWidgetViewNEW: View {
    
    @StateObject var cafeteriaWidgetVM : CafeteriaWidgetViewModel
    
    var body: some View {
        NavigationLink(destination: VStack {
            CafeteriaView(
            vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
            selectedCanteen: .constant(self.cafeteriaWidgetVM.cafeteria!),
            canDismiss: false
        )
            MealPlanView(viewModel: self.cafeteriaWidgetVM.mealPlanViewModel!)
        }
            ) {
            if let cafeteria = self.cafeteriaWidgetVM.cafeteria {
                Label {
                    HStack {
                        Text(cafeteria.name).foregroundColor(Color.primaryText)
                        Spacer()
                        Text("menu").foregroundColor(Color.highlightText)
                        Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                    }
                } icon: {
                    Image(systemName: "fork.knife").foregroundColor(Color.primaryText)
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
            } else {
                
            }
        }
        .frame(width: Size.cardWidth)
        .background(Color.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}

