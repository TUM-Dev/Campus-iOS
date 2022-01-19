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
        VStack(alignment: .leading, spacing: 5) {
            Text(lectureDetails.title)
                .font(.title)
                .multilineTextAlignment(.leading)
            Text(lectureDetails.eventType)
                .font(.subheadline)
        }
    }
}

struct LectureDetailTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsTitleView(lectureDetails: LectureDetails.dummyData)
    }
}
