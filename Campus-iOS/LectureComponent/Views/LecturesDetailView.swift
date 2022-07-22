//
//  LecturesDetailView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import SwiftUI

struct LecturesDetailView: View {
    var lectureDetails: LectureDetails
    var calendarEvent: CalendarEvent?
    
    var body: some View {
        VStack(alignment: .leading) {
            LectureDetailsTitleView(lectureDetails: lectureDetails)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if let event = self.calendarEvent {
                        // TODO: Should open room search once implemented
                        LectureDetailsEventInfoView(event: event)
                    }
                    
                    LectureDetailsBasicInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsDetailedInfoView(lectureDetails: lectureDetails)
                    
                    LectureDetailsLinkView(lectureDetails: lectureDetails)
                    
                    Spacer()
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
    
    static var event = CalendarEvent(id: 1, title: "Some Title", descriptionText: "Some description", startDate: Date(), endDate: Date(), location: "Some Location")
    
    static var previews: some View {
        LecturesDetailView(lectureDetails: LectureDetails.dummyData, calendarEvent: event)
    }
}
