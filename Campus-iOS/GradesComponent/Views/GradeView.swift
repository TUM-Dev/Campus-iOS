//
//  GradeView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct GradeView: View {
    @Environment(\.colorScheme) var colorScheme
    var grade: Grade
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(
                        GradesViewModel.GradeColor.color(
                            for: Double(grade.grade.replacingOccurrences(of: ",", with: "."))
                        )
                    )
                    .frame(width: 60, height: 60)
                
				Text(grade.grade.isEmpty ? "tbd" : grade.grade)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .glowBorder(color: .gray, lineWidth: 1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(grade.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))

				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 16) {
						HStack {
							Image(systemName: "pencil.circle.fill")
								.frame(width: 12, height: 12)
								.foregroundColor(Color("tumBlue"))
							Text(grade.modusShort)
								.font(.system(size: 12))
                                .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
							Spacer()
						}
						.frame(minWidth: 0, maxWidth: .infinity)

						HStack {
							Image(systemName: "number.circle.fill")
								.frame(width: 12, height: 12)
								.foregroundColor(Color("tumBlue"))
							Text(grade.lvNumber)
								.font(.system(size: 12))
                                .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
							Spacer()
						}
						.frame(minWidth: 0, maxWidth: .infinity)
					}.foregroundColor(.init(.darkGray))

					HStack {
						Image(systemName: "person.circle.fill")
							.frame(width: 12, height: 12)
							.foregroundColor(Color("tumBlue"))
						Text(grade.examiner)
							.font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
							.fixedSize(horizontal: false, vertical: true)
					}.foregroundColor(.init(.darkGray))
				}
				.padding(.leading, 4)
            }
            .padding(.bottom, 4)
        }
        .padding(.vertical, 5)
    }
}

struct GradeView_Previews: PreviewProvider {
    static var previews: some View {
        GradeView(grade: Grade.dummyData.first!)
        GradeView(grade: Grade.dummyData.first!)
            .preferredColorScheme(.dark)
    }
}
