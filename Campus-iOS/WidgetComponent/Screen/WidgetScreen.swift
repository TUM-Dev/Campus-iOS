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
                
                Group {
                    HStack {
                        StudyRoomWidgetView(size: .square)
                        TuitionWidgetView(size: .square)
                    }
                    
                    TuitionWidgetView(size: .rectangle)
                    StudyRoomWidgetView(size: .rectangle)
                    StudyRoomWidgetView(size: .bigSquare)
                }
                
                Group {
                    HStack {
                        CafeteriaWidgetView(size: .square)
                        GradeWidgetView(model: model, size: .square)
                    }
                    CafeteriaWidgetView(size: .rectangle)
                    CafeteriaWidgetView(size: .bigSquare)
                    
                    GradeWidgetView(model: model, size: .rectangle)
                    GradeWidgetView(model: model, size: .bigSquare)
                }
                
                Group {
                    HStack {
                        CalendarWidgetView(size: .square)
                        CalendarWidgetView(size: .square)
                    }
                    
                    CalendarWidgetView(size: .rectangle)
                    CalendarWidgetView(size: .bigSquare)
                }

            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
