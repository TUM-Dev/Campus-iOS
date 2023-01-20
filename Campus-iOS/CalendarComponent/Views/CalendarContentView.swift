//
//  CalendarView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI
import KVKCalendar

struct CalendarContentView: View {
    @AppStorage("calendarWeekDays") var calendarWeekDays: Int = 7
    
    @State var selectedType: CalendarType = .week
    @State var selectedEventID: String?
    @State var isTodayPressed: Bool = false
    @State private var data = AppUsageData()
    
    let model: Model
    var events: [CalendarEvent] = []
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                // workaround since passing the calendar type to the view does not work
                switch self.selectedType {
                case .week:
                    CalendarDisplayView(
                        events: self.events.map({ $0.kvkEvent }),
                        type: .week,
                        selectedEventID: self.$selectedEventID,
                        frame: Self.getSafeAreaFrame(geometry: geo), todayPressed: self.$isTodayPressed, calendarWeekDays: UInt(calendarWeekDays))
                case .day:
                    CalendarDisplayView(
                        events: self.events.map({ $0.kvkEvent }),
                        type: .day,
                        selectedEventID: self.$selectedEventID,
                        frame: Self.getSafeAreaFrame(geometry: geo), todayPressed: self.$isTodayPressed, calendarWeekDays: UInt(calendarWeekDays))
                case .month:
                    CalendarDisplayView(
                        events: self.events.map({ $0.kvkEvent }),
                        type: .month,
                        selectedEventID: self.$selectedEventID,
                        frame: Self.getSafeAreaFrame(geometry: geo), todayPressed: self.$isTodayPressed, calendarWeekDays: UInt(calendarWeekDays))
                default:
                    EmptyView()
                }
            }
        }
        .sheet(item: self.$selectedEventID) { eventId in
            let chosenEvent = self.events
                .first(where: { $0.id.description == eventId })
            CalendarSingleEventView(
                viewModel: LectureDetailsViewModel(
                    model: model,
                                service: LectureDetailsService(),
                                // Yes, it is a really hacky solution...
                                lecture: Lecture(id: UInt64(chosenEvent?.lvNr ?? "") ?? 0, lvNumber: UInt64(chosenEvent?.lvNr ?? "") ?? 0, title: "", duration: "", stp_sp_sst: "", eventTypeDefault: "", eventTypeTag: "", semesterYear: "", semesterType: "", semester: "", semesterID: "", organisationNumber: 0, organisation: "", organisationTag: "", speaker: "")
                            ),
                event: chosenEvent
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    self.isTodayPressed = true
                    selectedType = .day
                }) {
                    Text("Today")
                }
            }
            ToolbarItem(placement: .principal) {
                Picker("Calendar Type", selection: $selectedType) {
                    ForEach(CalendarType.allCases, id: \.self) {
                        switch $0 {
                        case .week:
                            Text("Week")
                        case .day:
                            Text("Day")
                        case .month:
                            Text("Month")
                        default:
                            EmptyView()
                        }
                    }
                }
                .opacity(1.0)
                .pickerStyle(.segmented)
                .onAppear {
                    UISegmentedControl.appearance().backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
                    UISegmentedControl.appearance()
                        .selectedSegmentTintColor = .tumBlue
                    UISegmentedControl.appearance()
                        .setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    UISegmentedControl.appearance()
                        .setTitleTextAttributes([.foregroundColor: UIColor.useForStyle(dark: UIColor(red: 28/255, green: 171/255, blue: 246/255, alpha: 1), white: UIColor(red: 34/255, green: 126/255, blue: 177/255, alpha: 1))], for: .normal)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ProfileToolbar(model: model)
            }
        }
        .task {
            data.visitView(view: .calendar)
        }
        .onDisappear {
            data.didExitView()
        }
    }
    
    static func getSafeAreaFrame(geometry: GeometryProxy) -> CGRect {
        let origin = UIScreen.main.bounds.origin
        
        return CGRect(x: origin.x, y: origin.y, width: geometry.size.width, height: geometry.size.height)
    }
}

struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView(
            model: MockModel(),
            events: []
        )
    }
}
