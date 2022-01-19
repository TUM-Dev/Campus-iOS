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
    @State var selectedType: CalendarType = .week // I want this to change its calendar type.
    var body: some View {
        VStack{
            CalendarDisplayView(events: $events)
        }
    }
}
struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView()
    }
}
