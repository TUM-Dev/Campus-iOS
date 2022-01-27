//
//  CalendarView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI
import KVKCalendar
struct CalendarContentView: View {
    @State var events: [Event] = []
    @State var selectedType: TumCalendarTypes = .day
    
    var body: some View {
        VStack{
            Picker("Calendar Type", selection: $selectedType) {
                ForEach(TumCalendarTypes.allCases, id: \.self) {
                    Text($0.localizedString)
                }
            }
            .pickerStyle(.segmented)
            CalendarDisplayView(events: $events, type: $selectedType)
        }
    }
}
struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView()
    }
}
