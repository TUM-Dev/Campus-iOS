//
//  SearchResultBar.swift
//  Campus-iOS
//
//  Created by David Lin on 12.02.23.
//

import SwiftUI

enum BarType: String {
    case all = "All"
    case grade = "Grades"
    case calendar = "Perosnal Lectures"
    case news = "News"
    case cafeteria = "Cafeterias"
    case studyRoom = "StudyRooms"
    case movie = "Movies"
    case roomFinder = "Room Finder"
    case lectureSearch = "Lecture Search"
    case personSearch = "Person Search"
}

struct SearchResultBarView: View {
    let types: [BarType] = [.all, .grade, .movie, .news, .cafeteria, .calendar, .roomFinder, .lectureSearch, .personSearch]
    @Binding var selectedType: BarType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(types, id: \.rawValue) { barType in
                    ZStack {
                        if selectedType == barType {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tumBlue)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                        }
                        Text(barType.rawValue)
                            .foregroundColor(.white)
                            .padding([.trailing, .leading])
                    }.onTapGesture {
                        withAnimation {
                            self.selectedType = barType
                        }
                    }
                }
            }
        }
    }
}

struct SearchResultBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultBarView(selectedType: .constant(.grade))
            .frame(height: 20)
    }
}
