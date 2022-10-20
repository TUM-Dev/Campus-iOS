//
//  Date.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation

// Source: https://stackoverflow.com/a/44469113/20105132
extension Date {
    
    class Time: Comparable, Equatable, Hashable {
        
        private let hour : Int
        
        private let minute: Int
        
        private let secondsSinceBeginningOfDay: Int
        
        var date: Date {
            get {
                let calendar = Calendar.current
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                return calendar.date(byAdding: dateComponents, to: Date())!
            }
        }
        
        init(_ date: Date) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
            let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
            secondsSinceBeginningOfDay = dateSeconds
            hour = dateComponents.hour!
            minute = dateComponents.minute!
        }
        
        init(_ hour: Int, _ minute: Int) {
            let dateSeconds = hour * 3600 + minute * 60
            secondsSinceBeginningOfDay = dateSeconds
            self.hour = hour
            self.minute = minute
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(secondsSinceBeginningOfDay)
        }
        
        static func == (lhs: Time, rhs: Time) -> Bool {
            return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
        }
        
        static func < (lhs: Time, rhs: Time) -> Bool {
            return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
        }
        
        static func <= (lhs: Time, rhs: Time) -> Bool {
            return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
        }
        
        static func >= (lhs: Time, rhs: Time) -> Bool {
            return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
        }
        
        static func > (lhs: Time, rhs: Time) -> Bool {
            return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
        }
        
        static func minutesBetween(_ time1: Time, _ time2: Time) -> Int {
            let seconds = abs(time1.secondsSinceBeginningOfDay - time2.secondsSinceBeginningOfDay)
            return seconds / 60
        }
    }
    
    var time: Time {
        return Time(self)
    }
}
