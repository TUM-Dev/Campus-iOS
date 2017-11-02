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
    
    @IBOutlet weak var plannerView: MGCDayPlannerView!
    var daySelector: ASWeekSelectorView?
    
    var items = [String : [CalendarRow]]()
    
    weak var delegate: DetailViewDelegate?
    
    var nextLectureItem: CalendarRow?
    
    var scrolling = false
    
    var firstTimeAppearing = true
    
    var refreshBarButton = UIBarButtonItem()
    var stopRefreshBarButton = UIBarButtonItem()
    var todayBarButton = UIBarButtonItem()
    
    func showToday(_ sender: AnyObject?) {
        daySelector?.setSelectedDate(.now, animated: true)
        updateTitle(.now)
        goToTime(.now, scrollToTime: true)
        plannerView.reloadAllEvents()
    }
    
    func updateCalendar(_ sender: AnyObject?) {
        navigationItem.rightBarButtonItems = [stopRefreshBarButton, todayBarButton]
        fetch(skippingCache: true)
    }
    
    func lecturesOfDate(_ date: Date) -> [CalendarRow] {
        return items[date.dayString] ?? []
    }
    
    func updateTitle(_ date: Date) {
        title = date.string(using: "MMMM dd")
    }
    
}

extension CalendarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Caledar"
        self.fetch()
        let size = CGSize(width: view.frame.width, height: 80.0)
        let origin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y+64)
        daySelector = ASWeekSelectorView(frame: CGRect(origin: origin, size: size))
        daySelector?.firstWeekday = 2
        daySelector?.letterTextColor = UIColor(white: 0.5, alpha: 1.0)
        daySelector?.delegate = self
        daySelector?.selectedDate = .now
        
        
        todayBarButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.showToday(_:)))
        refreshBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.updateCalendar(_:)))
        stopRefreshBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: nil)
        navigationItem.rightBarButtonItems = [refreshBarButton, todayBarButton]
        
        updateTitle(.now)
        plannerView.frame = CGRect(x: plannerView.frame.origin.x,
                                      y: plannerView.frame.origin.y,
                                      width: view.frame.width,
                                      height: plannerView.frame.width)
        
        plannerView.dataSource = self
        plannerView.delegate = self
        plannerView.numberOfVisibleDays = 1
        plannerView.dayHeaderHeight = 0.0
        plannerView.showsAllDayEvents = false
        self.view.addSubview(daySelector!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeAppearing {
            if let item = nextLectureItem {
                let date = item.start
                daySelector?.setSelectedDate(date, animated: true)
                updateTitle(date)
                goToTime(date, scrollToTime: true)
            } else {
                scrollTo(.now, scrollToTime: true, animated: false)
            }
            firstTimeAppearing = false
        }
    }
    
}

extension CalendarViewController {
    
    func goToDay(_ date: Date) {
        let newDate = lecturesOfDate(date).first?.start ?? date
        goToTime(newDate)
    }
    
    func goToTime(_ date: Date, scrollToTime: Bool = false) {
        scrolling = true
        scrollTo(date, scrollToTime: scrollToTime)
    }
    
    func sameDay(_ a: Date, b: Date) -> Bool {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        return dateformatter.string(from: a) == dateformatter.string(from: b)
    }
    
    func scrollTo(_ date: Date, scrollToTime: Bool) {
        scrollTo(date, scrollToTime: scrollToTime, animated: true)
    }
    
    func scrollTo(_ date: Date, scrollToTime: Bool, animated: Bool) {
        let interval = TimeInterval(-1200.0)
        var newDate = Date(timeInterval: interval, since: date)
        if !sameDay(newDate, b: date) {
            newDate = date
        }
        plannerView.scroll(to: newDate, options: scrollToTime ? .dateTime : .date, animated: animated)
    }
    
}

extension CalendarViewController {
    
    func fetch(skippingCache: Bool = false) {
        let manager = delegate?.dataManager()?.calendarManager
        let promise = skippingCache ? manager?.update() : manager?.fetch()
        promise?.onSuccess(in: .main) { entries in
            self.items = entries.grouped(by: \.start.dayString)
            self.updateTitle(.now)
            self.plannerView.reloadAllEvents()
            self.daySelector?.refresh()
            self.navigationItem.rightBarButtonItems = [self.refreshBarButton, self.todayBarButton]
        }
    }
}

extension CalendarViewController: ASWeekSelectorViewDelegate {
    
    func weekSelector(_ weekSelector: ASWeekSelectorView!, didSelect date: Date!) {
        updateTitle(date)
        goToDay(date)
    }
    
    func weekSelector(_ weekSelector: ASWeekSelectorView!, numberColorFor date: Date!) -> UIColor! {
        return Constants.tumBlue
    }
    
    func weekSelector(_ weekSelector: ASWeekSelectorView!, showIndicatorFor date: Date!) -> Bool {
        return !lecturesOfDate(date).isEmpty
    }
    
}

extension CalendarViewController: MGCDayPlannerViewDataSource {
    
    func dayPlannerView(_ view: MGCDayPlannerView!, canMoveEventOf type: MGCEventType, at index: UInt, date: Date!, to targetType: MGCEventType, date targetDate: Date!) -> Bool {
        return false
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, canCreateNewEventOf type: MGCEventType, at date: Date!) -> Bool {
        return false
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, numberOfEventsOf type: MGCEventType, at date: Date!) -> Int {
        return lecturesOfDate(date).count
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCEventView! {
        let eventView = MGCStandardEventView()
        eventView.color = Constants.tumBlue
        let item = lecturesOfDate(date)[(Int)(index)]
        eventView.title = item.text
        eventView.subtitle = item.location
        eventView.detail = item.description
        return eventView
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, dateRangeForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCDateRange! {
        let item = lecturesOfDate(date)[(Int)(index)]
        return MGCDateRange(start: item.start, end: item.end)
    }
    
}

extension CalendarViewController: MGCDayPlannerViewDelegate {
    
    func dayPlannerView(_ view: MGCDayPlannerView!, willDisplay date: Date!) {
        if !scrolling {
            daySelector?.setSelectedDate(date, animated: true)
            updateTitle(date)
        } else if sameDay(date, b: (daySelector?.selectedDate)!) {
            scrolling = false
        }
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, didSelectEventOf type: MGCEventType, at index: UInt, date: Date!) {
        let item = lecturesOfDate(date)[(Int)(index)]
        item.open(sender: self)
    }
    
    func dayPlannerView(_ view: MGCDayPlannerView!, shouldSelectEventOf type: MGCEventType, at index: UInt, date: Date!) -> Bool {
        let item = lecturesOfDate(date)[(Int)(index)]
        return item.url != nil
    }
    
}
