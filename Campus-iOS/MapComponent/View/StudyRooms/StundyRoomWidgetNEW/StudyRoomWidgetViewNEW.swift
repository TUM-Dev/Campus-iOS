//
//  StudyRoomWidgetViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.02.23.
//

import SwiftUI

struct StudyRoomWidgetViewNEW: View {
    
    @StateObject var studyRoomWidgetVM : StudyRoomWidgetViewModel
    
    var body: some View {
        if let studyGroup = studyRoomWidgetVM.studyGroup {
            Text(studyGroup.name!)
                .padding()
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
        }
    }
}
