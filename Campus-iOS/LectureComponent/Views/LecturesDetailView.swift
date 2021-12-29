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
		VStack(alignment: .leading) {
            LectureDetailsTitleView(lectureDetails: lectureDetails)

			Spacer()
				.frame(height: 30)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LectureDetailsBasicInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsDetailedInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsLinkView(lectureDetails: lectureDetails)
                }
            }
		}
		.frame(
			maxWidth: .infinity,
			alignment: .topLeading
		)
		.padding(.horizontal)
    }
}

struct LectureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LecturesDetailView(lectureDetails: LectureDetails.dummyData)
    }
}
