//
//  CalendarWidgetEventView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 19.01.23.
//

import SwiftUI

struct CalendarWidgetEventView: View, Identifiable {
    
    let id = UUID()
    let event: CalendarEvent
    var title = Date.distantPast
    @State private var height: CGFloat = 0
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        
        if title < Date.now {
            if let startDate = event.startDate,
               let endDate = event.endDate,
               let title = event.title {
                HStack(alignment: .top) {
                    Capsule()
                        .frame(width: 2, height: height)
                        .foregroundColor(.highlightText)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 11))
                            .bold()
                            .lineLimit(1)
                        
                        Group {
                            let timeText = timeFormatter.string(from: startDate) +
                                " - " + timeFormatter.string(from: endDate)
                            
                            Label(timeText, systemImage: "clock")
                                .lineLimit(1)
                            
                            if let location = event.location {
                                Label(location, systemImage: "mappin")
                                    .lineLimit(1)
                            } else {
                                Label("Paradise", systemImage: "mappin")
                                    .lineLimit(1)
                            }
                        }
                        .font(.system(size: 11))
                    }
                    
                    // Via https://stackoverflow.com/a/60346544
                    .alignmentGuide(.top, computeValue: { d in
                        DispatchQueue.main.async {
                            self.height = max(d.height, self.height)
                        }
                        return d[.top]
                    })
                    .padding(.bottom, 10)
                }
            } else {
                Text("Error")
            }
        }
        else if title.isToday {
            EmptyView()
        }
        else if title.isTomorrow {
            Text(title, format: .dateTime.weekday(.wide)).font(.system(size: 11)).fontWeight(.bold).textCase(.uppercase).foregroundColor(.gray).padding(.bottom, 5)
        }
        else {
            Text(title, format: .dateTime.weekday(.wide)).font(.system(size: 11)).fontWeight(.bold).textCase(.uppercase).foregroundColor(.gray).padding(.bottom, 5)
        }
    }
}
