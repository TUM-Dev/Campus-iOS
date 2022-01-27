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

    @Binding var events: [Event]
    @Binding var type: TumCalendarTypes
    
    public init(events: Binding<[Event]>, type: Binding<TumCalendarTypes>) {
        self._events = events
        self._type = type
    }
    
    private var calendar: CalendarView = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.isAnimateTitleDate = true
            style.headerScroll.isAnimateSelection = true
            style.headerScroll.heightHeaderWeek = 70
            style.event.isEnableVisualSelect = false
            style.month.isHiddenEventTitle = true
            style.headerScroll.titleDateFont = .boldSystemFont(ofSize: 18)
            style.month.weekDayAlignment = .center
        } else {
            style.timeline.widthEventViewer = 350
            style.headerScroll.fontNameDay = .systemFont(ofSize: 20)
        }
        style.headerScroll.colorBackground = .systemBackground
        style.headerScroll.colorBackgroundCurrentDate = .tumBlue
        style.headerScroll.colorCurrentDate = .white
        style.month.autoSelectionDateWhenScrolling = true
        style.timeline.offsetTimeY = 25
        // cuts out the hours before the first event if true
        style.timeline.startFromFirstEvent = false
        style.allDay.backgroundColor = .systemBackground
        style.startWeekDay = .monday
        style.defaultType = CalendarType.day
        style.timeSystem = .current ?? .twelve
        style.systemCalendars = ["Calendar"]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        style.locale = Locale.current
        style.timezone = TimeZone.current
        return CalendarView(frame: UIScreen.main.bounds, style: style)
    }()
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        context.coordinator.events = events
        
        calendar.set(type: type.calendarType, date: Date()) /// I've never used this library, so you might need to replace `Date()` with something else
        calendar.reloadData()
   }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
        private let view: CalendarDisplayView
        
        var events: [Event] = [] {
            didSet {
                view.calendar.reloadData()
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
            super.init()
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
            return events
        }
    }
    
}
