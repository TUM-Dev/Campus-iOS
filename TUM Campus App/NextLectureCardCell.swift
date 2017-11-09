//
//  NextLectureCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class NextLectureCardCell: CardTableViewCell {

    @IBOutlet weak var lectureTitelLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func setElement(_ element: DataElement) {
        if let calendarItem = element as? CalendarRow {
            lectureTitelLabel.text = calendarItem.text
            locationLabel.text = calendarItem.location
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm"
            
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "EEEE"
            
            let day = dayformatter.string(from: calendarItem.start)
            let start = dateformatter.string(from: calendarItem.start)
            let end = dateformatter.string(from: calendarItem.end)
            
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
            dateComponentsFormatter.maximumUnitCount = 2
            dateComponentsFormatter.unitsStyle = .full
            
            timeLabel.text = day + ", " + start + " - " + end
            
            if let timeRemaining = dateComponentsFormatter.string(from: .now, to: calendarItem.start) {
                timeRemainingLabel.text = "In \(timeRemaining)"
            }
        }
    }
}
