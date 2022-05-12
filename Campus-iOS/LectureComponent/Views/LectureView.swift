//
//  LectureView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LectureView: View {
    @Environment(\.colorScheme) var colorScheme
    var lecture: Lecture
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lecture.title)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("tumBlue"))
                        Text(lecture.eventType)
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .gray)
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("tumBlue"))
                        Text(lecture.duration + " SWS")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .gray)
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }.foregroundColor(.init(.darkGray))
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color("tumBlue"))
                    Text(lecture.speaker)
                        .font(.system(size: 12))
                        .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .gray)
                        .fixedSize(horizontal: false, vertical: true)
                }.foregroundColor(.init(.darkGray))
            }
            .padding(.leading, 4)
        }
        .padding(.vertical, 8)
    }
}

struct LectureView_Previews: PreviewProvider {
    static var previews: some View {
        LectureView(lecture: Lecture.dummyData.first!)
    }
}
