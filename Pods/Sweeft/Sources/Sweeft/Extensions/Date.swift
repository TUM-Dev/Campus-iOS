//
//  Date.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

public enum Weekday: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var index: Int {
        return rawValue
    }
}

extension Weekday: Defaultable {
    
    /// Default Value
    public static var defaultValue: Weekday = .sunday
    
}

public enum Month: Int {
    case january, february, march, april, may, june, july, august, september, october, november, december
    
    var index: Int {
        return rawValue
    }
}

extension Month: Defaultable {
    
    /// Default Value
    public static var defaultValue: Month = .january
    
}

public extension Date {
    
    /**
     Will turn a Date into a readable format
     
     - Parameter format: format in which you want the date (Optional: default is "dd.MM.yyyy hh:mm:ss a")
     
     - Returns: String representation of the date
     */
    func string(using format: String = "dd.MM.yyyy hh:mm:ss a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    private func getValue(for unit: Calendar.Component) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let value = calendar.dateComponents([unit], from: self).value(for: unit)
        return value.?
    }
    
    static var now: Date {
        return Date()
    }
    
    var nanosecond: Int {
        return getValue(for: .nanosecond)
    }
    
    var second: Int {
        return getValue(for: .second)
    }
    
    var minute: Int {
        return getValue(for: .minute)
    }
    
    var hour: Int {
        return getValue(for: .hour)
    }
    
    var day: Int {
        return getValue(for: .day)
    }
    
    var weekday: Weekday {
        return Weekday.init(rawValue: getValue(for: .weekday) - 1).?
    }
    
    var week: Int {
        return getValue(for: .weekOfYear)
    }
    
    var weekOfMonth: Int {
        return getValue(for: .weekOfMonth)
    }
    
    var month: Month {
        return Month.init(rawValue: getValue(for: .month) - 1).?
    }
    
    var year: Int {
        return getValue(for: .year)
    }
    
}

extension Date: Defaultable {
    
    /// Default Value
    public static var defaultValue: Date {
        return .now
    }
    
}

/// Struct representing a difference between two dates
public struct DateDifference {
    
    /// Left date
    let first: Date
    /// Right date
    let second: Date
    
    private func difference(by granularity: Calendar.Component) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let set = [granularity].set
        let components = calendar.dateComponents(set, from: second, to: first)
        return components.value(for: granularity).?
    }
    
    /// Regular TimeInterval between the two dates
    public var timeInterval: TimeInterval {
        return first.timeIntervalSince(second)
    }
    
    /// The change in timezones
    public var timeZones: Int {
        return difference(by: .timeZone)
    }
    
    /// The difference in nanoseconds
    public var nanoSeconds: Int {
        return difference(by: .nanosecond)
    }
    
    /// The difference in seconds
    public var seconds: Int {
        return difference(by: .second)
    }
    
    /// The difference in minutes
    public var minutes: Int {
        return difference(by: .minute)
    }
    
    /// The difference in hours
    public var hours: Int {
        return difference(by: .hour)
    }
    
    /// The difference in days
    public var days: Int {
        return difference(by: .day)
    }
    
    /// The difference in weeks
    public var weeks: Int {
        return difference(by: .weekOfYear)
    }
    
    /// The difference in years
    public var years: Int {
        return difference(by: .year)
    }
    
    /// The difference in millenia. For some reason
    public var millenia: Int {
        return years / 1000
    }
    
    
}

extension Date: Serializable {
    
    /// JSON Value
    public var json: JSON {
        return .string(string())
    }
    
}
