//
//  CalendarViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/7/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import ASWeekSelectorView
import CalendarLib

class CalendarViewController: UIViewController, DetailView {
    
    @IBOutlet weak var dayPlannerView: MGCDayPlannerView!
    var weekSelector: ASWeekSelectorView?
    
    var items = [String:[CalendarRow]]()
    
    var delegate: DetailViewDelegate?
    
    var nextLectureItem: CalendarRow?
    
    var scrolling = false
    
    var firstTimeAppearing = true
    
    var refreshBarButton = UIBarButtonItem()
    var stopRefreshBarButton = UIBarButtonItem()
    var todayBarButton = UIBarButtonItem()
    
    func showToday(_ sender: AnyObject?) {
        let now = Date()
        weekSelector?.setSelectedDate(now, animated: true)
        updateTitle(now)
        scrolling = true
        scrollTo(now)
        dayPlannerView.reloadAllEvents()
    }
    
    func updateCalendar(_ sender: AnyObject?) {
        print("updateCalendar clicked")
        navigationItem.rightBarButtonItems = [stopRefreshBarButton, todayBarButton]
        delegate?.dataManager().updateCalendar(self)
    }
    
    func lecturesOfDate(_ date: Date) -> [CalendarRow] {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let string = dateformatter.string(from: date)
        return items[string] ?? []
    }
    
    func updateTitle(_ date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd"
        title = dateformatter.string(from: date)
    }
    
}

extension CalendarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Caledar"
        let size = CGSize(width: view.frame.width, height: 80.0)
        let origin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y+64)
        weekSelector = ASWeekSelectorView(frame: CGRect(origin: origin, size: size))
        weekSelector?.firstWeekday = 2
        weekSelector?.letterTextColor = UIColor(white: 0.5, alpha: 1.0)
        weekSelector?.delegate = self
        weekSelector?.selectedDate = Date()
        delegate?.dataManager().getCalendar(self)
        
        todayBarButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.showToday(_:)))
        refreshBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.updateCalendar(_:)))
        stopRefreshBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: nil)
        navigationItem.rightBarButtonItems = [refreshBarButton, todayBarButton]
        
        updateTitle(Date())
        dayPlannerView.frame = CGRect(x: dayPlannerView.frame.origin.x, y: dayPlannerView.frame.origin.y, width: view.frame.width, height: dayPlannerView.frame.width)
        dayPlannerView.dataSource = self
        dayPlannerView.delegate = self
        dayPlannerView.numberOfVisibleDays = 1
        dayPlannerView.dayHeaderHeight = 0.0
        dayPlannerView.showsAllDayEvents = false
        self.view.addSubview(weekSelector!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeAppearing {
            if let item = nextLectureItem {
                let date = item.dtstart ?? Date()
                weekSelector?.setSelectedDate(date, animated: true)
                updateTitle(date)
                goToTime(date)
            } else {
                let now = Date()
                
                scrollTo(now, animated: false)
                firstTimeAppearing = false
            }
        }
    }
    
}

extension CalendarViewController {
    
    func goToDay(_ date: Date) {
        let newDate = lecturesOfDate(date).first?.dtstart ?? date
        goToTime(newDate)
    }
    
    func goToTime(_ date: Date) {
        scrolling = true
        scrollTo(date)
    }
    
    func sameDay(_ a: Date, b: Date) -> Bool {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        return dateformatter.string(from: a) == dateformatter.string(from: b)
    }
    
    func scrollTo(_ date: Date) {
        scrollTo(date, animated: true)
    }
    
    func scrollTo(_ date: Date, animated: Bool) {
        let interval = TimeInterval(-1200.0)
        var newDate = Date(timeInterval: interval, since: date)
        if !sameDay(newDate, b: date) {
            newDate = date
        }
        dayPlannerView.scroll(to: newDate, options: .dateTime, animated: animated)
    }
    
}

extension CalendarViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        items.removeAll()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        for item in data {
            if let lecture = item as? CalendarRow, let date = lecture.dtstart {
                if let _ = items[dateformatter.string(from: date as Date)] {
                    items[dateformatter.string(from: date as Date)]?.append(lecture)
                } else {
                    items[dateformatter.string(from: date as Date)] = [lecture]
                }
            }
        }
        let now = Date()
        updateTitle(now)
        navigationItem.rightBarButtonItems = [refreshBarButton, todayBarButton]
    }
}

extension CalendarViewController: ASWeekSelectorViewDelegate {
    
    func weekSelector(_ weekSelector: ASWeekSelectorView!, didSelect date: Date!) {
        updateTitle(date)
        goToDay(date)
    }
    
}

extension CalendarViewController: MGCDayPlannerViewDataSource, MGCDayPlannerViewDelegate {
    
    func dayPlannerView(_ view: MGCDayPlannerView!, canCreateNewEventOf type: MGCEventType, at date: Date!) -> Bool {
        return false
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, numberOfEventsOf type: MGCEventType, at date: Date!) -> Int {
        return lecturesOfDate(date).count
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, canMoveEventOf type: MGCEventType, at index: UInt, date: Date!, to targetType: MGCEventType, date targetDate: Date!) -> Bool {
        return false
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCEventView! {
        let eventView = MGCStandardEventView()
        eventView.color = Constants.tumBlue
        let item = lecturesOfDate(date)[(Int)(index)]
        eventView.title = item.text
        eventView.subtitle = item.location
        return eventView
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, dateRangeForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCDateRange! {
        let item = lecturesOfDate(date)[(Int)(index)]
        return MGCDateRange(start: item.dtstart! as Date!, end: item.dtend! as Date!)
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, willDisplay date: Date!) {
        if !scrolling {
            weekSelector?.setSelectedDate(date, animated: true)
            updateTitle(date)
        } else if sameDay(date, b: (weekSelector?.selectedDate)!) {
            scrolling = false
        }
    }
    
}
