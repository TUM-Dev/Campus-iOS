//
//  CalendarWidgetView2.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.01.23.
//

import SwiftUI

struct CalendarWidgetViewNEW: View {
    
    @State var vm: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Show the events on the earliest date which is not in the past.
            let futureEvents = self.vm.eventsByDateNEW.filter{$0.key! >= Date.now}.sorted(by: { $0.key!.compare($1.key!) == .orderedAscending })
            
            if futureEvents.isEmpty {
                EmptyView()
            } else {
                Text("Calendar").titleStyle()
                HStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(Date.now, format: .dateTime.weekday(.wide)).font(.system(size: 11)).fontWeight(.bold).textCase(.uppercase).foregroundColor(Color.highlightText)
                            Text(Date.now, format: .dateTime.day()).font(.largeTitle).fontWeight(.light)
                            
                            let leftEvents = self.vm.getWidgetEventViews(events: futureEvents).0
                            
                            if leftEvents.isEmpty {
                                Text("No events today").padding(.top)
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
                                Text("No more events")
                            } else {
                                ForEach(rightEvents) { event in
                                    event
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 5)
                }
                .sectionStyle()
            }
        }
    }
}
