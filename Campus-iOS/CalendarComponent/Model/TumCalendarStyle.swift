//
//  TumCalendarStyle.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 12.02.22.
//

import Foundation
import SwiftUI
import KVKCalendar

struct TumCalendarStyle {
    @available(*, unavailable) private init() {}
    
    static func getStyle(type: CalendarType, calendarWeekDays: UInt) -> Style {

        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.heightHeaderWeek = 60
            style.headerScroll.titleDateFont = .boldSystemFont(ofSize: 16)
            style.headerScroll.fontNameDay = .systemFont(ofSize: 14)
        } else {
            style.timeline.widthEventViewer = 0
            style.headerScroll.fontNameDay = .systemFont(ofSize: 20)
        }
        
        // Event
        style.event.showRecurringEventInPast = true
        style.event.isEnableVisualSelect = false
        style.event.states = [.none]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        
        // Header
        style.headerScroll.heightSubviewHeader = 40
        style.headerScroll.colorBackground = .primaryBackground
        style.headerScroll.colorBackgroundCurrentDate = .tumBlue
        style.headerScroll.colorCurrentDate = .white
        style.headerScroll.isAnimateTitleDate = true
        style.headerScroll.isAnimateSelection = true
        style.headerScroll.bottomLineColor = .lightGray.withAlphaComponent(0.5)
        style.headerScroll.titleDateColor = .primaryText
        style.headerScroll.colorDate = .primaryText
        style.headerScroll.colorNameDay = .primaryText
        style.headerScroll.colorBackgroundSelectDate = .primaryText //maybe add colour
        style.headerScroll.colorSelectDate = .contrastText
        style.headerScroll.colorCurrentSelectDateForDarkStyle = .primaryText
        

        // Timeline
        style.timeline.offsetTimeY = 25
        style.timeline.showLineHourMode = .today
        // cuts out the hours before the first event if true
        style.timeline.startFromFirstEvent = false
        style.timeline.backgroundColor = .primaryBackground
        
        // Day
        style.allDay.backgroundColor = .primaryBackground
        if type == .day {
            style.week.showVerticalDayDivider = false
        }
        
        // Week
        if type == .week {
            style.week.daysInOneWeek = calendarWeekDays
        }
        style.week.colorBackground = .primaryBackground
        style.week.colorDate = .primaryText
        style.week.colorSelectDate = .white //neccessary?

        
        // Month
        style.month.isHiddenEventTitle = false
        style.month.selectionMode = .single
        style.month.autoSelectionDateWhenScrolling = true
        style.month.scrollDirection = .vertical
        style.month.colorTitleHeader = .tumBlue
        style.month.colorBackgroundCurrentDate = .tumBlue
        style.month.colorBackgroundSelectDate = .black
        style.month.isHiddenDotInTitle = false
        style.month.isAnimateSelection = true
        style.month.colorTitleCurrentDate = .tumBlue
        style.month.weekDayAlignment = .center
        style.month.colorBackground = .primaryBackground
        style.month.colorDate = .primaryText
        style.month.colorCurrentDate = .white //neccessary?
        style.month.colorBackgroundSelectDate = .primaryText
        style.month.colorSelectDate = .contrastText
        style.month.colorBackgroundDate = .primaryBackground
        
        //Year
        style.year.colorBackgroundCurrentDate = .tumBlue
        style.year.colorBackgroundHeader = .primaryBackground
        style.year.colorBackground = .primaryBackground
        style.startWeekDay = .monday
        style.defaultType = type
        style.timeSystem = .current ?? .twelve
        style.systemCalendars = ["Calendar"]
        style.locale = Locale.current
        style.timezone = TimeZone.current
        // allows for custom dark mode colors
        style.followInSystemTheme = false
        
        //list view
        style.list.backgroundColor = .primaryBackground
        
        return style    }
    
    static func addDarkMode(style: Style) -> Style {
        
        var newStyle = style
        
        // Event
        newStyle.event.colorIconFile = UIColor.useForStyle(dark: .systemGray, white: newStyle.event.colorIconFile)
        
        // Header
        newStyle.headerScroll.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6,
                                                                      white: newStyle.headerScroll.colorNameEmptyDay)
        // newStyle.headerScroll.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.headerScroll.colorBackground)
        newStyle.headerScroll.titleDateColorCorner = UIColor.useForStyle(dark: .systemRed,
                                                                         white: newStyle.headerScroll.titleDateColorCorner)
        /*newStyle.headerScroll.colorCurrentDate = UIColor.useForStyle(dark: .systemGray6,
                                                                     white: newStyle.headerScroll.colorCurrentDate)
         
        newStyle.headerScroll.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                               white: newStyle.headerScroll.colorBackgroundCurrentDate)
         */
        
        newStyle.headerScroll.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2,
                                                                     white: newStyle.headerScroll.colorWeekendDate)
        
        // Timeline
        newStyle.timeline.timeColor = UIColor.useForStyle(dark: .systemGray, white: newStyle.timeline.timeColor)
        newStyle.timeline.currentLineHourColor = UIColor.useForStyle(dark: .systemRed,
                                                                     white: newStyle.timeline.currentLineHourColor)
        
        // Week
        newStyle.week.colorNameDay = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorNameDay)
        newStyle.week.colorCurrentDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorCurrentDate)
        newStyle.week.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray,
                                                                      white: newStyle.week.colorBackgroundSelectDate)
        newStyle.week.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemGray,
                                                                       white: newStyle.week.colorBackgroundCurrentDate)
        newStyle.week.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.week.colorWeekendDate)
        newStyle.week.colorWeekendBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekendBackground)
        newStyle.week.colorWeekdayBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekdayBackground)
        
        // Month
        newStyle.month.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6, white: newStyle.month.colorNameEmptyDay)
        /*newStyle.month.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                        white: newStyle.month.colorBackgroundCurrentDate)
         */
        
        
         
        newStyle.month.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.month.colorWeekendDate)
        newStyle.month.colorMoreTitle = UIColor.useForStyle(dark: .systemGray3, white: newStyle.month.colorMoreTitle)
        newStyle.month.colorEventTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorEventTitle)
        if UIDevice.current.userInterfaceIdiom == .phone {
            newStyle.month.colorSeparator = UIColor.useForStyle(dark: .systemGray4, white: newStyle.month.colorSeparator)
            newStyle.month.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .black,
                                                                            white: newStyle.month.colorBackgroundWeekendDate)
        } else {
            newStyle.month.colorSeparator = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorSeparator)
            newStyle.month.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .systemGray6,
                                                                            white: newStyle.month.colorBackgroundWeekendDate)
        }
        // newStyle.month.colorTitleHeader = UIColor.useForStyle(dark: .white, white: newStyle.month.colorTitleHeader)
        // newStyle.month.colorTitleCurrentDate = .useForStyle(dark: .systemRed, white: newStyle.month.colorTitleCurrentDate)
        
        // year
        newStyle.year.colorCurrentDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorCurrentDate)
        /*newStyle.year.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                       white: newStyle.year.colorBackgroundCurrentDate)
        */
        newStyle.year.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray,
                                                                      white: newStyle.year.colorBackgroundSelectDate)
        newStyle.year.colorSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorSelectDate)
        newStyle.year.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.year.colorWeekendDate)
        newStyle.year.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .clear,
                                                                       white: newStyle.year.colorBackgroundWeekendDate)
        newStyle.year.colorTitle = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitle)
        newStyle.year.colorTitleHeader = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitleHeader)
        newStyle.year.colorDayTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.year.colorDayTitle)
        
        // all day
        newStyle.allDay.titleColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.titleColor)
        newStyle.allDay.textColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.textColor)
        
        // list view
                
        return newStyle
    }
}
