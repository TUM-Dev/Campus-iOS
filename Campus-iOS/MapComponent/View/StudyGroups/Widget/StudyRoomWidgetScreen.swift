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
                EmptyView() // -> keine study rooms nearby
            case .loading:
                LoadingView(text: "Searching nearby study rooms")
            case .success:
                StudyRoomWidgetView(studyRoomWidgetVM: self.studyRoomWidgetVM)
}
        }
    }
}
