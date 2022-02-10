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

    @ObservedObject var viewModel: CalendarViewModel
    
    var selectDate: Date?
    private var calendar: CalendarView
    
    public init(viewModel: CalendarViewModel, type: CalendarType) {
        self.viewModel = viewModel
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
            style.event.isEnableVisualSelect = true
            style.month.isHiddenEventTitle = false
            style.month.selectionMode = .single
            style.headerScroll.titleDateFont = .boldSystemFont(ofSize: 18)
            style.month.weekDayAlignment = .center
        } else {
            style.timeline.widthEventViewer = 350
            style.headerScroll.fontNameDay = .systemFont(ofSize: 20)
        }
        style.event.showRecurringEventInPast = true
        style.headerScroll.colorBackground = .systemBackground
        style.headerScroll.colorBackgroundCurrentDate = .tumBlue
        style.headerScroll.colorCurrentDate = .white
        style.month.autoSelectionDateWhenScrolling = true
        style.month.scrollDirection = .vertical
        style.month.colorTitleHeader = .tumBlue
        style.month.colorBackgroundCurrentDate = .black
        style.month.colorBackgroundSelectDate = .tumBlue
        style.month.isHiddenDotInTitle = false
        style.month.selectCalendarType = .day
        style.month.isAnimateSelection = true
        style.month.colorTitleCurrentDate = .tumBlue
        style.timeline.offsetTimeY = 25
        // cuts out the hours before the first event if true
        style.timeline.startFromFirstEvent = false
        style.allDay.backgroundColor = .systemBackground
        style.startWeekDay = .monday
        style.defaultType = type
        style.timeSystem = .current ?? .twelve
        style.systemCalendars = ["Calendar"]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        style.locale = Locale.current
        style.timezone = TimeZone.current
        self.calendar = CalendarView(frame: UIScreen.main.bounds, style: style)
    }
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.scrollTo(Date(), animated: true)
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        context.coordinator.events = viewModel.events.map({ $0.kvkEvent })
        calendar.reloadData()
        calendar.reloadInputViews()
   }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
        private let view: CalendarDisplayView
        
        var selectedDate: Date
        
        var events: [Event] = [] {
            didSet {
                if let firstEvent = events.filter( {$0.start.isToday && $0.end > Date()} ).sorted(by: {
                    return $0.start > $1.start
                }).first {
                    view.calendar.scrollTo(firstEvent.start, animated: true)
                }
                view.calendar.reloadData()
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
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
            if let firstEvent = events.filter( {$0.start.startOfDay == date.startOfDay} ).sorted(by: {
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
            view.viewModel.lastSelectedEventId = event.ID
        }
    }
    
}
