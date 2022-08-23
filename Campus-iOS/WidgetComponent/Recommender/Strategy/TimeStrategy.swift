//
//  TimeStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation

struct TimeStrategy: WidgetRecommenderStrategy {
    
    func getRecommendation() async -> [WidgetRecommendation] {
        
        let widgets = Widget.allCases.map {  WidgetRecommendation(widget: $0, priority: priority(of: $0)) }
        
        return widgets.filter { $0.priority > 0 }
    }
    
    private func priority(of widget: Widget) -> Int {
        var priority: Int = 1
        
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.month, .day, .hour, .weekday], from: currentDate)
        
        guard let month = components.month, let day = components.day, let hour = components.hour,
              let weekday = components.weekday else {
            return 0
        }
        
        switch widget {
            
        case .cafeteria:
            
            // There is no menu on weekends.
            if weekday == 1 || weekday == 7 {
                priority = 0
                break
            }
            
            /* Cafeteria opening hours. */
            
            // The menu is not interesting anymore after the cafeteria has closed.
            if 14 <= hour {
                priority = 0
                break
            }
            
            // The menu might be interesting before the opening hours.
            if hour < 14 && 6 < hour {
                priority += 1
            }
            
            // Bonus points during the opening hours.
            if (11...13).contains(hour) {
                priority += 1
            }
            
        case .studyRoom:
            
            // TODO: find out real peak time for study rooms.
            if [9, 10, 11, 14, 15, 16, 17] .contains(hour) {
                priority += 2
            }
            
            // Bonus points if we are at the end of the semester (exams).
            if (month == 7 && day >= 15) || [2, 3, 8].contains(month) {
                priority += 1
            }
            
        case .calendar:
            
            // The calendar is most interesting during the semester.
            if (month == 4 && day >= 15) || [5, 6, 7].contains(month) || [10, 11, 12, 1].contains(month)
                || (month == 2 && day <= 15) {
                priority += 1
            }
            
        case .tuition:
            
            // 1 month before the deadline.
            if (month == 1 || month == 7) && day >= 15 {
                priority += 1
            }
            
            if (month == 2 || month == 8) && day < 15 {
                priority += 1
                
                if day >= 12 {
                    priority += 1
                }
            }
            
        case .grades:
            
            // Grades are most interesting after the exams, i.e. at the end of the semester.
            if (month == 2 && day > 15) || month == 3 || (month == 7 && day >= 15) || month == 8 {
                priority += 1
            }
            
            // Bonus points in August and March.
            if month == 3 || month == 8 {
                priority += 1
            }
        }
        
        return priority
    }
}

