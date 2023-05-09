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
                EmptyView() //muss mann noch besser handeln -> keine study rooms nearby
            case .loading:
                WidgetLoadingView(text: "Searching nearby study rooms")
            case .success:
                StudyRoomWidgetViewNEW(studyRoomWidgetVM: self.studyRoomWidgetVM)
}
        }
    }
}
