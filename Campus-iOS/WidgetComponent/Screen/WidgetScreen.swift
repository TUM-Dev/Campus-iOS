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
                
                TuitionWidgetView(size: .rectangle)
                    .padding(.bottom)
                
                CafeteriaWidgetView(size: .rectangle)
                    .padding(.bottom)
                
                WidgetView(
                    size: .rectangle,
                    content: StudyRoomWidgetView(
                        viewModel: StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
                    )
                )
                .padding(.bottom)
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
