//
//  GradeView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct GradeView: View {
    var grade: Grade
    
    var body: some View {
        /*
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tv")
                    .font(.system(size: 12, weight: .black))
                Text(grade.title)
            }
            
            Text(makeAttributedString(title: "Examiner", label: grade.examiner))
            Text(makeAttributedString(title: "Grade", label: grade.grade))
                .lineLimit(2)
        }
         */
        HStack(alignment: .center, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(
                        GradesViewModel.GradeColor.color(
                            for: Double(grade.grade.replacingOccurrences(of: ",", with: "."))
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text(grade.grade)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(grade.title)
                    .fontWeight(.bold)
                
                HStack(alignment: .center, spacing: 8) {
                    HStack{
                        Image(systemName: "pencil.circle")
                            .frame(width: 12, height: 12)
                            .padding(.leading, 3)
                        Text(grade.modus.short)
                            .font(.system(size: 12))
                            .padding(.trailing, 5)
                    }.foregroundColor(.init(.darkGray))
                    
                    HStack{
                        Image(systemName: "person.circle")
                            .frame(width: 12, height: 12)
                        Text(grade.examiner)
                            .font(.system(size: 12))
                            .padding(.trailing, 5)
                    }.foregroundColor(.init(.darkGray))
                    
                    HStack{
                        Image(systemName: "number.circle")
                            .frame(width: 12, height: 12)
                        Text(grade.lvNumber)
                            .font(.system(size: 12))
                    }.foregroundColor(.init(.darkGray))
                }
            }
            .padding(.leading, 8)
        }
        .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: .topLeading
        )
        .padding(.vertical, 5)
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

struct GradeView_Previews: PreviewProvider {
    static var previews: some View {
        GradeView(grade: Grade.dummyData.first!)
    }
}
