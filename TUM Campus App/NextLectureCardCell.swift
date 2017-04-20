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
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.textColor = Constants.tumBlue
        }
    }
    
    override func setElement(_ element: DataElement) {
        if let calendarItem = element as? CalendarRow {
            lectureTitelLabel.text = calendarItem.text
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm"
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "EEEE"
            if let s = calendarItem.dtstart, let e = calendarItem.dtend {
                let day = dayformatter.string(from: s as Date)
                let start = dateformatter.string(from: s as Date)
                let end = dateformatter.string(from: e as Date)
                
                let dateComponentsFormatter = DateComponentsFormatter()
                dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
                dateComponentsFormatter.maximumUnitCount = 2
                dateComponentsFormatter.unitsStyle = .full
                
                timeLabel.text = day + ", " + start + " - " + end
                
                if let timeRemaining = dateComponentsFormatter.string(from: Date(), to: s) {
                    timeRemainingLabel.text = "In \(timeRemaining)"
                }
            }
        }
    }
   
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clear
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }

}
