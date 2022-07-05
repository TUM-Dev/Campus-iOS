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
                
                WidgetView(
                    size: .rectangle,
                    title: "Tuition Fee",
                    content: TuitionWidgetView(viewModel: ProfileViewModel())
                )
                
                WidgetView(
                    size: .rectangle,
                    title: "Nearest Cafeteria",
                    content: CafeteriaWidgetView(
                        viewModel: CafeteriaWidgetViewModel(cafeteriaService: CafeteriasService())
                    )
                )
                
                WidgetView(
                    size: .rectangle,
                    title: "Nearest Study Rooms",
                    content: StudyRoomWidgetView(
                        viewModel: StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
                    )
                )
                
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
