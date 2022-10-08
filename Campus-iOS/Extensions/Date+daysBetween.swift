//
//  Date+daysBetween.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation

extension Date{
    static func daysBetween(_ date1: Date, _ date2: Date) -> Int {
        return abs(Calendar.current.dateComponents([.day], from: date1, to: date2).day!)
    }
}
