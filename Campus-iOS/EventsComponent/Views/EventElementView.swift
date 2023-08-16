//
//  EventElementView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import SwiftUI

struct EventElementView: View {
    var event: TUMEvent
    
    var body: some View {
        HStack(spacing: 15) {
            VStack (alignment: .leading, spacing: 5){
                Text(event.title).font(.title2)
//                Text(event.user + " | " + event.category).font(.subheadline)
//                Text("By: " + event.user).font(.subheadline)
                
                HStack {
                    Text(event.category)
                        .foregroundColor(.blue)
                        .font(.caption)
                }
                .padding(3)
                .background(Color(.systemGray3))
                .cornerRadius(3)
            }
            Spacer()
            Text(getFormattedDate(date: event.date)).font(.title2)
            
            
        }
        .padding(20)
        .cornerRadius(10)
    }
                     
     func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
     }
}

struct EventElementView_Previews: PreviewProvider {
    static let event = TUMEvent(user: "Me", title: "Party!", category: "software engineering", date: Date(), link: "https://www.tum.dev", body: "Party!", image: nil)
    static var previews: some View {
        EventElementView(event: event)
    }
}
