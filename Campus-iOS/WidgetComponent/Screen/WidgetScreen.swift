//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
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
                
                // TODO: update widgets

                
                // CafeteriaWidgetView(size: .rectangle)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("My Widgets")
    }
}

struct WidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        WidgetScreen()
        WidgetScreen()
            .preferredColorScheme(.dark)
    }
}
