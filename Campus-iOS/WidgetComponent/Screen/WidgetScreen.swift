//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        ScrollView {
            VStack {
                
                HStack {
                    StudyRoomWidgetView(size: .square)
                    TuitionWidgetView(size: .square)
                }
                
                TuitionWidgetView(size: .rectangle)
                StudyRoomWidgetView(size: .rectangle)
                StudyRoomWidgetView(size: .bigSquare)
                
                HStack {
                    CafeteriaWidgetView(size: .square)
                    GradeWidgetView(model: model, size: .square)
                }
                CafeteriaWidgetView(size: .rectangle)
                CafeteriaWidgetView(size: .bigSquare)
                
                GradeWidgetView(model: model, size: .rectangle)
                GradeWidgetView(model: model, size: .bigSquare)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
