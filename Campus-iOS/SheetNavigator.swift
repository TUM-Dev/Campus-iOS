//
//  Sheet.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import SwiftUI

class SheetNavigator: ObservableObject {
    
    @Published var showSheet = true
    var sheetDestination: SheetDestination = .none {
        didSet {
            switch(sheetDestination) {
            case .none:
                showSheet = false
            default:
                showSheet = true
            }
        }
    }
    
    func sheetView() -> some View {
        switch sheetDestination {
        case .none:
            return AnyView(Text("Should not come here!"))
        case .loginSheet(model: let model):
            return AnyView(LoginView(model: model))
        case .profileSheet(model: let model):
            return AnyView(ProfileView(model: model))
        }
    }
}
