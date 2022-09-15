//
//  TuitionCard.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionCard: View {
    
    @State var tuition: Tuition
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                Rectangle().foregroundColor(Color(red: 8/255, green: 100/255, blue: 188/255))
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                    .clipped()
                Image("logo-white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 175, height: 100, alignment: .center)
            }
            
            // Stack bottom half of card
            TuitionDetailsView(tuition: self.tuition)
                .padding(12)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
    }
}

struct TuitionCard_Previews: PreviewProvider {
    
    static var tuition = Tuition(deadline: Date(), semester: "Winter Semester 2021/2022", semesterID: "22", amount: 0)

    static var previews: some View {
        Group {
            TuitionCard(tuition: tuition)
            TuitionCard(tuition: tuition)
                .preferredColorScheme(.dark)
        }
    }
}
