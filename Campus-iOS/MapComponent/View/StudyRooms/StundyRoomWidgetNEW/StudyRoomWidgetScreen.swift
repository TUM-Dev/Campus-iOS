//
//  StudyRoomWidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.02.23.
//

import SwiftUI

struct StudyRoomWidgetScreen: View {
    
    @StateObject var studyRoomWidgetVM : StudyRoomWidgetViewModel
    
    var body: some View {
        Group {
            switch(self.studyRoomWidgetVM.status) {
            case .error:
                TextWidgetView(text: "No nearby study rooms.")
            case .loading:
                WidgetLoadingView(text: "Searching nearby study rooms")
            case .success:
                StudyRoomWidgetViewNEW(studyRoomWidgetVM: self.studyRoomWidgetVM)
}
        }
    }
}

struct StudyRoomWidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomWidgetScreen(studyRoomWidgetVM: StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService()))
    }
}
