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
                    StudyRoomWidgetView(size: .square)
                }

                StudyRoomWidgetView(size: .rectangle)
                StudyRoomWidgetView(size: .bigSquare)
                
                // TODO: update widgets
                // TuitionWidgetView(size: .rectangle)
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
