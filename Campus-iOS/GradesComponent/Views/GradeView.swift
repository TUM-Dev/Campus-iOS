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
}

struct GradeView_Previews: PreviewProvider {
    static var previews: some View {
        GradeView(grade: Grade.dummyData.first!)
    }
}
