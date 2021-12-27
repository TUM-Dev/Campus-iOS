//
//  LectureView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LectureView: View {
    var lecture: Lecture
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lecture.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .frame(width: 12, height: 12)
                        Text(lecture.eventType)
                            .font(.system(size: 12))
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .frame(width: 12, height: 12)
                        Text(lecture.duration + " SWS")
                            .font(.system(size: 12))
                    }
                }.foregroundColor(.init(.darkGray))
                
                HStack {
                    Image(systemName: "person.circle")
                        .frame(width: 12, height: 12)
                    Text(lecture.speaker)
                        .font(.system(size: 12))
                        .fixedSize(horizontal: false, vertical: true)
                }.foregroundColor(.init(.darkGray))
            }
            .padding(.leading, 4)
        }
        .multilineTextAlignment(.leading)
        .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: .topLeading
        )
        .padding(.vertical ,8)
    }
}

struct LectureView_Previews: PreviewProvider {
    static var previews: some View {
        LectureView(lecture: Lecture.dummyData.first!)
    }
}
