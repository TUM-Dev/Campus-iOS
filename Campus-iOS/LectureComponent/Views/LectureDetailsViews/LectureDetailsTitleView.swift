//
//  LectureDetailsTitleView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LectureDetailsTitleView: View {
    var lectureDetails: LectureDetails
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(lectureDetails.title)
                .font(.system(.title))
                .multilineTextAlignment(.center)
            Text(lectureDetails.eventType)
                .font(.system(.subheadline))
        }
    }
}

struct LectureDetailTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsTitleView(lectureDetails: LectureDetails.dummyData)
    }
}
