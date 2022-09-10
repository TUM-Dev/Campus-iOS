//
//  AppUsageData.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 09.09.22.
//

import Foundation
import MapKit
import Combine

/// A wrapper for the usage data we collect for specific views inside the app.
/// Persists the data when explicitly calling `exitView`, or when the app enters the background.
/// Instantiate as a `@State` object inside the view, and call `visitView` in `.onAppear` or `.task`.
/// Call `exitView` in `.onDisappear`.
class AppUsageData {
    
    /* CoreData's double values (for latitude, longitude) are not optional.
     * However, we still want to store the other data when we cannot get the location.
     * Thus we symbolize invalid locations with an impossible latitude / longitude value in the CoreData entity. */
    static let invalidLocation: Double = 200
    
    private var view: CampusAppView?
    private var latitude: Double?
    private var longitude: Double?
    private var startTime: Date?
    private var endTime: Date?
    
    // To set the end timestamp, and persist the data when the app enters the background.
    private var didEnterBackgroundListener: AnyCancellable?
    
    // To set the start timestamp (etc.) when the app wakes up.
    private var wakeUpListener: AnyCancellable?
    
    func visitView(view: CampusAppView) {
        
        self.startTime = Date()
        self.view = view
        
        guard let location = CLLocationManager().location else {
            self.latitude = nil
            self.longitude = nil
            return
        }
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
                
        self.didEnterBackgroundListener = NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .sink { _ in
                
                // Restart on app wake up (but only if we entered the background).
                self.wakeUpListener = NotificationCenter.default
                    .publisher(for: UIApplication.didBecomeActiveNotification)
                    .sink { _ in
                        self.visitView(view: view)
                    }
                
                self.exitView(closingApp: true)
            }
    }
    
    func exitView(closingApp: Bool) {
        
        
        if !closingApp {
            self.wakeUpListener?.cancel()
        }
        
        didEnterBackgroundListener?.cancel()
        
        self.endTime = Date()
        
        AnalyticsController.store(entry: self)
        
        Task {
            try? await AnalyticsController.upload(entry: self)
        }
    }
    
    public func getView() -> CampusAppView? {
        return self.view
    }
    
    public func getLatitude() -> Double? {
        return self.latitude
    }
    
    public func getLongitude() -> Double? {
        return self.longitude
    }
    
    public func getStartTime() -> Date? {
        return self.startTime
    }
    
    public func getEndTime() -> Date? {
        return self.endTime
    }
}
