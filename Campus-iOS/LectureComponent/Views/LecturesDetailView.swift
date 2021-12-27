//
//  LecturesDetailView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LecturesDetailView: View {
    var lectureDetails: LectureDetails
    
    var body: some View {
        VStack {
            LectureDetailsTitleView(lectureDetails: lectureDetails)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 3) {
                    LectureDetailsBasicInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsDetailedInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsLinkView(lectureDetails: lectureDetails)
                }
            }
        }
    }
}

struct LectureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesDetailView(lectureDetails: LectureDetails.dummyData)
    }
}
