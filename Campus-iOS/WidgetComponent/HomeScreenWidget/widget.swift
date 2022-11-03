//
//  widget.swift
//  widget
//
//  Created by Robyn Kölle on 30.10.22.
//

import WidgetKit
import SwiftUI

@main
struct CampusAppWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        SmartWidget()
        CalendarWidget()
        GradeWidget()
        StudyRoomWidget()
        CafeteriaWidget()
        TuitionWidget()
    }
}
