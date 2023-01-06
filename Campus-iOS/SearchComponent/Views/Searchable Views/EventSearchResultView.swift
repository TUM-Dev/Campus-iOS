//
//  CalendarLectureSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 28.12.22.
//

import SwiftUI

struct EventSearchResultView: View {
    @Binding var query: String
    @StateObject var vm: EventSearchResultViewModel
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.event) { result in
                    VStack {
                        Text(result.event.lecture.title)
                        if result.event.events != [] {
                            VStack {
                                Text("Next events").bold()
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(result.event.events, id: \.id) { event in
                                            VStack {
                                                Text(event.location ?? "No location")
                                                Text(formattedStartDate(event.startDate) ?? "No start date")
                                                Text("\(formattedTime(event.startDate) ?? "") - \(formattedTime(event.endDate) ?? "")")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .border(.green)
                }
            }
        }
        
        .onChange(of: query) { newQuery in
            Task {
                await vm.eventsSearch(for: query)
            }
        }
    }
    
    func formattedStartDate(_ optionalStartDate: Date?) -> String? {
        guard let startDate = optionalStartDate else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: startDate)
    }
    
    func formattedTime(_ optionalTime: Date?) -> String? {
        guard let time = optionalTime else {
            return nil
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeStyle = .medium
        timeFormatter.dateStyle = .none
        
        return timeFormatter.string(from: time)
    }
}
