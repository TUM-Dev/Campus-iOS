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
                WidgetView(content: TuitionWidgetView(viewModel: ProfileViewModel()))
                WidgetView(
                    content: CafeteriaWidgetView(
                        viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
                    )
                )
                WidgetView(
                    content: StudyRoomWidgetView(
                        viewModel: StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())))
            }
            .padding()
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
