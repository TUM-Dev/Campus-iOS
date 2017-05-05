//
//  CalendarRowSet.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit


class CalendarRowSet:DataElement {
    
    var calendarList = [CalendarRow]()
    
    func getCellIdentifier() -> String {
        return "calendarRowSet"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 112
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 412
    }
    
    var text: String {
        return ""
    }
    
}
