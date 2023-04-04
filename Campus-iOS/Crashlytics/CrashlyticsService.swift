//
//  CrashlyticsService.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 28.01.23.
//

import Foundation
import FirebaseCrashlytics

class CrashlyticsService {
    static private let crashlytics = Crashlytics.crashlytics()
    
    static func log(_ error: Error) -> Void {
        #if !DEBUG
        CrashlyticsService.crashlytics.record(error: error)
        #endif
    }
    
    static func log(_ error: String) -> Void {
        #if !DEBUG
        CrashlyticsService.crashlytics.log(value)
        #endif
    }
}
