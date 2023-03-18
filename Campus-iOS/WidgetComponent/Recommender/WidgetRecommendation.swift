//
//  WidgetRecommendation.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation

struct WidgetRecommendation {
    let widget: Widget
    let priority: Int
    
    func size() -> WidgetSize {
        if priority < 2 {
            return .square
        }
        
        if priority < 3 {
            return .rectangle
        }
        
        return .bigSquare
    }
}
