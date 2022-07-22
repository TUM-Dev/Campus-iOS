//
//  CalendarDisplayView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI
import EventKit
import KVKCalendar

struct CalendarDisplayView: UIViewRepresentable {

    @Binding var selectedEventID: String?
    @Binding var todayPressed: Bool
    
    private var events: [Event]
    private var calendar: CalendarView
    var selectDate: Date?
    
    init(events: [Event], type: CalendarType, selectedEventID: Binding<String?>, frame: CGRect, todayPressed: Binding<Bool>, calendarWeekDays: UInt) {
        self.events = events
        self._todayPressed = todayPressed
        self._selectedEventID = selectedEventID
        self.calendar = CalendarView(frame: frame, style: TumCalendarStyle.getStyle(type: type, calendarWeekDays: calendarWeekDays))
    }
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        DispatchQueue.main.async {
            calendar.scrollTo(Date(), animated: true)
            calendar.reloadData()
        }
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        context.coordinator.events = self.events
        // changing calendar type after initial initialization of CalendarView is not supported (bug with KVKCalendar)
        // calendar.set(type: .day, date: Date())
        if self.todayPressed {
            calendar.scrollTo(Date(), animated: true)
            self.todayPressed = false
        }
        calendar.reloadData()
        calendar.reloadInputViews()
   }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
        
        @Binding var selectedEventID: String?
        
        private var view: CalendarDisplayView
        var selectedDate: Date
        
        var events: [Event] = [] {
            didSet {
                if let firstEvent = events.filter( {$0.start.isToday && $0.end > Date()} ).sorted(by: {
                    return $0.start > $1.start
                }).first {
                    view.calendar.scrollTo(firstEvent.start, animated: true)
                } else if view.calendar.selectedType == .month {
                    return view.calendar.scrollTo(Date(), animated: true)
                }
                view.calendar.reloadData()
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
            self._selectedEventID = view.$selectedEventID
            self.selectedDate = view.selectDate ?? Date()
            super.init()
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
            return events
        }
        
        func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
            
            guard let date = dates.first, date != Date() else {
                self.selectedDate = Date()
                view.calendar.reloadData()
                return
            }
            
            self.selectedDate = date
            if let firstEvent = events.filter( {$0.start.kvkStartOfDay == date.kvkStartOfDay} ).sorted(by: {
                return $0.start > $1.start
            }).first {
                view.calendar.scrollTo(firstEvent.start, animated: true)
            }
            view.calendar.reloadData()
        }
        
        func willSelectDate(_ date: Date, type: CalendarType) {
            view.calendar.reloadData()
        }
        
        func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
            selectedEventID = event.ID
        }
    }
    
}

//struct CalendarDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarDisplayView(...)
//    }
//}
