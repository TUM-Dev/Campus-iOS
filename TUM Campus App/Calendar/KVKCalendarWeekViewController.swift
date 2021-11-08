//
//  KVKCalendarWeekViewController.swift
//  TUMCampusApp
//
//  Created by Milen Vitanov on 07.11.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import XMLCoder
import KVKCalendar
import EventKit

final class KVKCalendarWeekViewController: UIViewController, ProfileImageSettable {
    typealias ImporterType = Importer<CalendarEvent,APIResponse<CalendarAPIResponse,TUMOnlineAPIError>,XMLDecoder>

    @IBOutlet private weak var profileImageBarButtonItem: UIBarButtonItem!
    
    var profileImage: UIImage? {
        get { return profileImageBarButtonItem.image }
        set { profileImageBarButtonItem.image = newValue?.imageAspectScaled(toFill: CGSize(width: 32, height: 32)).imageRoundedIntoCircle().withRenderingMode(.alwaysOriginal) }
    }
    
    private static let endpoint: URLRequestConvertible = TUMOnlineAPI.calendar
    private static let primarySortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.startDate, ascending: true)
    private static let secondarySortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.id, ascending: true)
    private static let predicate = NSPredicate(format: "%K != %@", #keyPath(CalendarEvent.status), "CANCEL")
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: primarySortDescriptor, secondarySortDescriptor, predicate: predicate, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    
    var events = [Event]()
    var selectDate: Date?
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(frame: view.frame, date: self.selectDate ?? Date(), style: self.style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.selectDate = Date()
        loadProfileImage()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = self.view.safeAreaInsets;
        let frame = CGRect(
            x: safeAreaInsets.left,
            y: safeAreaInsets.top - 1.15 * safeAreaInsets.bottom,
            width: self.view.frame.size.width - safeAreaInsets.left - safeAreaInsets.right,
            height: self.view.frame.size.height - safeAreaInsets.top - safeAreaInsets.bottom
        )
        calendarView.reloadFrame(frame)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }
    
    private var style: Style = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.isAnimateTitleDate = true
            style.headerScroll.heightHeaderWeek = 70
            style.event.isEnableVisualSelect = false
            style.month.isHiddenTitle = true
            style.headerScroll.titleDateFont = .boldSystemFont(ofSize: 18)
            style.month.weekDayAlignment = .center
        } else {
            style.timeline.widthEventViewer = 350
            style.headerScroll.fontNameDay = .systemFont(ofSize: 17)
        }
        style.headerScroll.colorBackground = .systemBackground
        style.headerScroll.colorBackgroundCurrentDate = .tumBlue
        style.headerScroll.colorCurrentDate = .white
        style.month.autoSelectionDateWhenScrolling = true
        style.timeline.offsetTimeY = 25
        style.timeline.backgroundColor = .systemBackground
        style.timeline.timeColor = .tumBlue
        style.allDay.backgroundColor = .systemBackground
        style.allDay.isPinned = true
        style.defaultType = CalendarType.day
        style.timeSystem = .current ?? .twelve
        style.event.iconFile = UIImage(systemName: "paperclip")
        
        return style
    }()

    private func setupUI() {
        title = "Calendar".localized
        edgesForExtendedLayout = UIRectEdge.all
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(self.calendarView)
        
        self.fetch(animated: true)
        
        loadEvents { (events) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.events = events
                self?.calendarView.reloadData()
            }
        }
    }

    @objc private func fetch(animated: Bool = true) {
        importer.performFetch(success: { [weak self] in
            self?.reload()
        }, error: { [weak self] error in
            switch error {
            case is TUMOnlineAPIError:
                guard let context = self?.importer.context else { break }
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
                _ = try? context.execute(deleteRequest) as? NSBatchDeleteResult
                self?.reload()
            default: break
            }
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()
        self.calendarView.reloadData()
    }

    // MARK: - EventDataSource

    func eventsForDate(_ date: Date) -> [Event] {
        let events = importer.fetchedResultsController.fetchedObjects ?? []
        return events
            .compactMap { CalendarEventViewModel(event: $0) }
            .compactMap(({ (item) -> Event in
            var event = Event(ID: UUID().uuidString)
            event.start = item.startDate // start date event
            event.end = item.endDate // end date event
            event.color = Event.Color(item.color)
            event.isAllDay = item.isAllDay
            event.isContainsFile = false

            // Add text event (title, info, location, time)
            if item.isAllDay {
                event.text = item.text
            } else {
                event.text = "\(item.startDate) - \(item.endDate)\n\(item.text)"
            }
            return event
        }))
    }
    
    // MARK: - Actions

    @IBAction func showToday(_ sender: Any) {
        self.selectDate = Date()
        self.calendarView.scrollTo(selectDate ?? Date())
        self.calendarView.reloadData()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        loadEvents { [weak self] (events) in
//            self?.events = events
//            self?.calendarView.reloadData()
//        }
//    }

}

// MARK: - load events

extension KVKCalendarWeekViewController {
    func loadEvents(completion: ([Event]) -> Void) {
        let models = importer.fetchedResultsController.fetchedObjects ?? []
        
        let viewModels = models.compactMap({ CalendarEventViewModel(event: $0) })
        
        let events = viewModels.compactMap(({ (item) -> Event in
            var event = Event(ID: UUID().uuidString)
            event.start = item.startDate // start date event
            event.end = item.endDate // end date event
            event.color = Event.Color(item.color)
            event.isAllDay = item.isAllDay
            event.isContainsFile = false

            // Add text event (title, info, location, time)
            if item.isAllDay {
                event.text = item.text
            } else {
                event.text = "\(item.startDate) - \(item.endDate)\n\(item.text)"
            }
            return event
        }))
        completion(events)
    }
}

extension KVKCalendarWeekViewController: CalendarDataSource {
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get events from iOS calendars
        // set calendar names to style.systemCalendars = ["Test"]
        let mappedEvents = systemEvents.compactMap({ $0.transform() })
        return events + mappedEvents
    }
}

extension KVKCalendarWeekViewController: CalendarDelegate {
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        selectDate = dates[0]
        loadEvents( completion: { [unowned self] (events) in
           self.events = events
           self.calendarView.reloadData()
        })
        self.reload()
    }

    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
//        switch type {
//        case .day:
//            eventViewer.text = event.text
//        default:
//            break
//        }
    }

    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        
    }
    
    func didAddNewEvent(_ event: Event, _ date: Date?) {
        
    }
    
//    func eventViewerFrame(_ frame: CGRect) {
//        eventViewer.reloadFrame(frame: frame)
//    }
}
