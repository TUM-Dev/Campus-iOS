//
//  CalendarWidgetViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.01.23.
//

import SwiftUI

struct CalendarWidgetScreen: View {
    
    @StateObject var vm: CalendarViewModel
    
    var body: some View {
        switch self.vm.state {
        case .success(data: let events):
            CalendarWidgetViewNEW(vm: self.vm, events: events!)
        case .loading:
            ProgressView()
        case .failed(error: let error):
            Text("Error").onAppear{
                print(error)
            }
        case .na:
            Text("nothing")
        }
    }
}

struct CalendarWidgetViewNEW: View {
    
    @State var vm: CalendarViewModel
    let events: [CalendarEvent]
    
    var body: some View {
        
        // Show the events on the earliest date which is not in the past.
        let futureEvents = self.vm.eventsByDateNEW.filter{$0.key! >= Date.now}.sorted(by: { $0.key!.compare($1.key!) == .orderedAscending })
        
        HStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(Date.now, format: .dateTime.weekday(.wide)).font(.system(size: 11)).fontWeight(.bold).textCase(.uppercase).foregroundColor(Color.highlightText)
                    Text(Date.now, format: .dateTime.day()).font(.largeTitle).fontWeight(.light)
                    
                    let leftEvents = self.vm.getWidgetEventViews(events: futureEvents).0
                    
                    if leftEvents.isEmpty {
                        Text("No Events Today").padding(.top)
                    } else {
                        ForEach(leftEvents) { event in
                            event
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
            }
            .padding(.trailing, 5)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    let rightEvents = self.vm.getWidgetEventViews(events: futureEvents).1
                    
                    if rightEvents.isEmpty {
                        Text("No Events Today")
                    } else {
                        ForEach(rightEvents) { event in
                            event
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                
                Spacer(minLength: 0)
            }.padding(.leading, 5)
        }
        .sectionStyle()
    }
}

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
                            .font(.system(size: 12))
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
                        .font(.system(size: 12))
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
