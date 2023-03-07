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
    @State var showEventsFor: EventSearchResult? = nil
    @State var showDetailedLecture: Lecture? = nil
    @State var size: ResultSize = .small
    
    var results: [(event: EventSearchResult, distance: Distances)] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack{
                VStack {
                    ZStack {
                        Text("Lectures")
                            .fontWeight(.bold)
                            .font(.title)
                        HStack {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
                                        self.size = .big
                                    }
                                }
                            } label: {
                                if self.size == .small {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                } else {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                ScrollView {
                    ForEach(self.results, id: \.event) { result in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(result.event.lecture.title)
                                
                                Spacer()
                                NavigationLink {
                                    LectureDetailsScreen(model: vm.model, lecture: result.event.lecture)
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.tumBlue)
                                }
                                
                            }
                            if result.event.events.count > 0 {
                                Button {
                                    withAnimation {
                                        self.showEventsFor = showEventsFor == result.event ? nil : result.event
                                    }
                                } label: {
                                    if self.showEventsFor == result.event {
                                        Text("Hide next events")
                                            .fontWeight(.light)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("Show next events")
                                            .fontWeight(.light)
                                            .foregroundColor(.gray)
                                    }
                                    
                                }
                                if let shownResultEvents = showEventsFor, showEventsFor == result.event {
                                    ScrollView {
                                        VStack {
                                            ForEach(shownResultEvents.events, id: \.id) { event in
                                                VStack(alignment: .leading, spacing: 8) {
                                                    LectureDetailsBasicInfoRowView(
                                                        iconName: "hourglass",
                                                        text: duration(event)
                                                    )
                                                    Divider()
                                                    // Open RoomfinderView
                                                    VStack (alignment: .leading) {
                                                        LectureDetailsBasicInfoRowView(
                                                            iconName: "rectangle.portrait.arrowtriangle.2.inward",
                                                            text: location(event)
                                                        )
                                                        HStack {
                                                            Spacer()
                                                            NavigationLink(destination: RoomFinderView(model: vm.model, viewModel: RoomFinderViewModel(), searchText: extract(room: location(event)))) {
                                                                HStack {
                                                                    Text("Open in RoomFinder")
                                                                    Image(systemName: "arrow.right.circle")
                                                                }.foregroundColor(Color(UIColor.tumBlue))
                                                                    .font(.footnote)
                                                            }
                                                        }
                                                    }
                                                    Divider()
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }.padding()
                    }
                }
            }
        }
        .onChange(of: query) { newQuery in
            Task {
                await vm.eventsSearch(for: query)
            }
        }.task {
            await vm.eventsSearch(for: query)
        }
    }
    
    func duration(_ event: CalendarEvent) -> String {
        if let start = event.startDate, let end = event.endDate {
            return "\(Self.startDateFormatter.string(from: start)) - \(Self.endDateFormatter.string(from: end))"
        }
        return "n/a"
    }
    
    func location(_ event: CalendarEvent) -> String {
        if let location = event.location {
            return location
        }
        return "n/a"
    }
    
    static let startDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EE, dd.MM.yyyy, HH:mm"
        return formatter
    }()
    
    static let endDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func extract(room: String) -> String {
        var roomNumber = room
        
        if let openBraceRange = roomNumber.range(of: "(") {
            roomNumber.removeSubrange(roomNumber.startIndex..<openBraceRange.upperBound)
        }
        
        if let closeBraceRange = roomNumber.range(of: ")") {
            roomNumber.removeSubrange(closeBraceRange.lowerBound..<roomNumber.endIndex)
        }
        
        return roomNumber
    }
}

struct EventSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        EventSearchResultView(query: .constant("Analysis"), vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct LecturesService_Preview: LecturesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Lecture] {
        return Lecture.dummyData
    }
}

struct CalendarService_Preview: CalendarServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [CalendarEvent] {
        return CalendarEvent.previewData
    }
}
