//
//  WidgetRecommendation.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.07.22.
//

import Foundation

struct WidgetRecommendation {
    let widget: CampusAppWidget
    let priority: Int
    let widgetSize: WidgetSize
    
    init(widget: CampusAppWidget, priority: Int, widgetSize: WidgetSize = .square) {
        self.widget = widget
        self.priority = priority
        self.widgetSize = widgetSize
    }
    
    // TODO: remove this method when strategies recommend widget sizes.
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
