//
//  LocationStrategy_Test.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 07.11.22.
//

import XCTest
import CoreLocation

@testable import Campus_iOS

final class LocationStrategy_Test: XCTestCase {
    
    private let stucafeConollyLocation = CLLocation(latitude: 48.179393, longitude: 11.546589)
    private let studiTumInnenstadtLocation = CLLocation(latitude: 48.148013, longitude: 11.566615)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPositivePriorityNearCafeteria() async throws {
        let locationManager = MockLocationManager(
            latitude: stucafeConollyLocation.coordinate.latitude,
            longitude: stucafeConollyLocation.coordinate.longitude
        )
        
        let strategy = LocationStrategy(locationManager: locationManager)
        let priority = try await strategy.getRecommendation().first{ $0.widget == CampusAppWidget.cafeteria }!.priority
        XCTAssertGreaterThan(priority, 0)
    }
    
    func testPositivePriorityNearStudiTum() async throws {
        let locationManager = MockLocationManager(
            latitude: studiTumInnenstadtLocation.coordinate.latitude,
            longitude: studiTumInnenstadtLocation.coordinate.longitude
        )
        
        let strategy = LocationStrategy(locationManager: locationManager)
        let priority = try await strategy.getRecommendation().first{ $0.widget == CampusAppWidget.studyRoom }!.priority
        XCTAssertGreaterThan(priority, 0)
    }
    
    func testNoCafeteriaRecommendationFarAway() async throws {
        let locationManager = MockLocationManager(latitude: 1, longitude: 1)
        let strategy = LocationStrategy(locationManager: locationManager)
        let recommendation = try await strategy.getRecommendation().first{ $0.widget == CampusAppWidget.cafeteria }
        XCTAssertTrue(recommendation == nil)
    }
    
    func testNoStudyRoomRecommendationFarAway() async throws {
        let locationManager = MockLocationManager(latitude: 1, longitude: 1)
        let strategy = LocationStrategy(locationManager: locationManager)
        let recommendation = try await strategy.getRecommendation().first{ $0.widget == CampusAppWidget.studyRoom }
        XCTAssertTrue(recommendation == nil)
    }
}
