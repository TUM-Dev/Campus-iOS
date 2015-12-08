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

class CalendarViewController: UIViewController, TumDataReceiver, ASWeekSelectorViewDelegate, MGCDayPlannerViewDataSource, MGCDayPlannerViewDelegate {
    
    var items = [String:[CalendarRow]]()
    
    var delegate: DetailViewDelegate?
    
    var weekSelector: ASWeekSelectorView?
    
    var nextLectureItem: CalendarRow?
    
    var scrolling = false
    
    var firstTimeAppearing = true
    
    func showToday(sender: AnyObject?) {
        let now = NSDate()
        weekSelector?.setSelectedDate(now, animated: true)
        updateTitle(now)
        scrolling = true
        scrollTo(now)
        dayPlannerView.reloadAllEvents()
    }
    
    @IBOutlet weak var dayPlannerView: MGCDayPlannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Caledar"
        let size = CGSize(width: view.frame.width, height: 80.0)
        let origin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y+64)
        weekSelector = ASWeekSelectorView(frame: CGRect(origin: origin, size: size))
        weekSelector?.firstWeekday = 2
        weekSelector?.letterTextColor = UIColor(white: 0.5, alpha: 1.0)
        weekSelector?.delegate = self
        weekSelector?.selectedDate = NSDate()
        delegate?.dataManager().getCalendar(self)
        let barItem = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain, target: self, action:  Selector("showToday:"))
        navigationItem.rightBarButtonItem = barItem
        updateTitle(NSDate())
        dayPlannerView.frame = CGRectMake(dayPlannerView.frame.origin.x, dayPlannerView.frame.origin.y, view.frame.width, dayPlannerView.frame.width)
        dayPlannerView.dataSource = self
        dayPlannerView.delegate = self
        dayPlannerView.numberOfVisibleDays = 1
        dayPlannerView.dayHeaderHeight = 0.0
        dayPlannerView.showsAllDayEvents = false
        self.view.addSubview(weekSelector!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receiveData(data: [DataElement]) {
        items.removeAll()
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        for item in data {
            if let lecture = item as? CalendarRow, date = lecture.dtstart {
                if let _ = items[dateformatter.stringFromDate(date)] {
                    items[dateformatter.stringFromDate(date)]?.append(lecture)
                } else {
                    items[dateformatter.stringFromDate(date)] = [lecture]
                }
            }
        }
        let now = NSDate()
        updateTitle(now)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeAppearing {
            if let item = nextLectureItem {
                let date = item.dtstart ?? NSDate()
                weekSelector?.setSelectedDate(date, animated: true)
                updateTitle(date)
                goToTime(date)
            } else {
                let now = NSDate()
                
                scrollTo(now, animated: false)
                firstTimeAppearing = false
            }
        }
    }
    
    func lecturesOfDate(date: NSDate) -> [CalendarRow] {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let string = dateformatter.stringFromDate(date)
        return items[string] ?? []
    }
    
    func goToDay(date: NSDate) {
        let newDate = lecturesOfDate(date).first?.dtstart ?? date
        goToTime(newDate)
    }
    
    func goToTime(date: NSDate) {
        scrolling = true
        scrollTo(date)
    }
    
    func updateTitle(date: NSDate) {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMMM dd"
        title = dateformatter.stringFromDate(date)
    }
    
    func weekSelector(weekSelector: ASWeekSelectorView!, didSelectDate date: NSDate!) {
        updateTitle(date)
        goToDay(date)
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, canCreateNewEventOfType type: MGCEventType, atDate date: NSDate!) -> Bool {
        return false
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, numberOfEventsOfType type: MGCEventType, atDate date: NSDate!) -> Int {
        return lecturesOfDate(date).count
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, canMoveEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!, toType targetType: MGCEventType, date targetDate: NSDate!) -> Bool {
        return false
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, viewForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCEventView! {
        let eventView = MGCStandardEventView()
        eventView.color = Constants.tumBlue
        let item = lecturesOfDate(date)[(Int)(index)]
        eventView.title = item.title
        return eventView
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, dateRangeForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCDateRange! {
        let item = lecturesOfDate(date)[(Int)(index)]
        return MGCDateRange(start: item.dtstart!, end: item.dtend!)
    }
    
    func sameDay(a: NSDate, b: NSDate) -> Bool {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        return dateformatter.stringFromDate(a) == dateformatter.stringFromDate(b)
    }
    
    func dayPlannerView(view: MGCDayPlannerView!, willDisplayDate date: NSDate!) {
        if !scrolling {
            weekSelector?.setSelectedDate(date, animated: true)
        } else if sameDay(date, b: (weekSelector?.selectedDate)!) {
            scrolling = false
        }
    }
    
    func scrollTo(date: NSDate) {
        scrollTo(date, animated: true)
    }
    
    func scrollTo(date: NSDate, animated: Bool) {
        let interval = NSTimeInterval(-1200.0)
        var newDate = NSDate(timeInterval: interval, sinceDate: date)
        if !sameDay(newDate, b: date) {
            newDate = date
        }
        dayPlannerView.scrollToDate(newDate, options: MGCDayPlannerScrollDateTime, animated: animated)
    }
    
}
