//
//  GradeView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LectureView: View {
    var lecture: Lecture
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tv")
                    .font(.system(size: 12, weight: .black))
                Text(lecture.title)
            }
            
            Text(makeAttributedString(title: "Semester", label: lecture.semester))
            Text(makeAttributedString(title: "Speaker", label: lecture.speaker))
                .lineLimit(2)
        }
        .padding()
        .foregroundColor(.black)
    }
    
    private func makeAttributedString(title: String, label: String) -> AttributedString {
        var string = AttributedString("\(title): \(label)")
        string.foregroundColor = .black
        string.font = .system(size: 16, weight: .bold)
        
        if let range = string.range(of: label) {
            string[range].foregroundColor = .black.opacity(0.8)
            string[range].font = .system(size: 16, weight: .regular)
        }
        
        return string
    }
}

struct LectureView_Previews: PreviewProvider {
    static var previews: some View {
        LectureView(lecture: Lecture.dummyData.first!)
    }
}
