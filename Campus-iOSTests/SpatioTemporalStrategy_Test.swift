//
//  SpatioTemporalStrategy_Test.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 07.11.22.
//

import XCTest

@testable import Campus_iOS

final class SpatioTemporalStrategy_Test: XCTestCase {

    func testNoIrrelevantRecommendationsRegardingTime() async throws {
        let timeStrategy = MockTimeStrategy(recommendations: [WidgetRecommendation(widget: .studyRoom, priority: 0)])
        let locationStrategy = MockLocationStrategy(recommendations: [WidgetRecommendation(widget: .cafeteria, priority: 1)])
        let spatioTemporalStrategy = SpatioTemporalStrategy(timeStrategy: timeStrategy, locationStrategy: locationStrategy)
    
        let recommendations = try await spatioTemporalStrategy.getRecommendation()
        let irrelevantRecommendation = recommendations.first{ $0.widget == .studyRoom }
        XCTAssertTrue(irrelevantRecommendation == nil)
    }
    
    func testNoIrrelevantRecommendationsRegardingLocation() async throws {
        let timeStrategy = MockTimeStrategy(recommendations: [WidgetRecommendation(widget: .studyRoom, priority: 1)])
        let locationStrategy = MockLocationStrategy(recommendations: [WidgetRecommendation(widget: .cafeteria, priority: 0)])
        let spatioTemporalStrategy = SpatioTemporalStrategy(timeStrategy: timeStrategy, locationStrategy: locationStrategy)
    
        let recommendations = try await spatioTemporalStrategy.getRecommendation()
        let irrelevantRecommendation = recommendations.first{ $0.widget == .cafeteria }
        XCTAssertTrue(irrelevantRecommendation == nil)
    }
    
    func testIncludesAllRelevantRecommendations() async throws {
        let timeStrategy = MockTimeStrategy(recommendations: [WidgetRecommendation(widget: .studyRoom, priority: 1)])
        let locationStrategy = MockLocationStrategy(recommendations: [WidgetRecommendation(widget: .cafeteria, priority: 1)])
        let spatioTemporalStrategy = SpatioTemporalStrategy(timeStrategy: timeStrategy, locationStrategy: locationStrategy)
    
        let recommendations = try await spatioTemporalStrategy.getRecommendation()
        let cafeteriaRecommendation = recommendations.first{ $0.widget == .cafeteria }
        let studyRoomRecommendation = recommendations.first{ $0.widget == .studyRoom }

        XCTAssertTrue(cafeteriaRecommendation != nil && studyRoomRecommendation != nil)
    }

}
