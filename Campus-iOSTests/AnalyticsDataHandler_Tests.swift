//
//  AnalyticsDataHandler_Tests.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 07.11.22.
//

import XCTest
import CoreLocation

@testable import Campus_iOS

final class AnalyticsDataHandler_Tests: XCTestCase {
    
    private var nearbyEntities: [AppUsageDataEntity] = []
    private var diverseEntities: [AppUsageDataEntity] = []
    
    private let locationGroupRadius: CLLocationDistance = 500
    private let timeNearbyThreshold: Int = 120
    private let dateNearbyThreshold: Int = 7
    private let minGroupSize: Int = 1
    
    override func setUpWithError() throws {
        let entity1 = AppUsageDataEntity(context: PersistenceController.preview.container.viewContext)
        entity1.latitude = 42
        entity1.longitude = 42
        entity1.startTime = Date(timeIntervalSince1970: 42)
        entity1.endTime = Date(timeIntervalSince1970: 42)
        entity1.view = CampusAppView.grades.rawValue
        
        let entity2 = AppUsageDataEntity(context: PersistenceController.preview.container.viewContext)
        entity2.latitude = 32
        entity2.longitude = 32
        entity2.startTime = Date(timeIntervalSince1970: 42_000_000)
        entity2.endTime = Date(timeIntervalSince1970: 42_000_000)
        entity2.view = CampusAppView.studyRoom.rawValue
        
        nearbyEntities = [entity1, entity1]
        diverseEntities = [entity1, entity2]
    }
    
    func testCorrectPredictionBasedOnData() throws {
        let dataHandler = dataHandler(entities: diverseEntities)
        let model = try dataHandler.getModel()
        let params = [
            Covariate.date : dataHandler.discreteValue(for: Date(timeIntervalSince1970: 42)),
            Covariate.location : dataHandler.discreteValue(for: CLLocation(latitude: 42, longitude: 42)),
            Covariate.time : dataHandler.discreteValue(for: Date(timeIntervalSince1970: 42).time)
        ]
        
        let predictions = try dataHandler.getPredictions(model: model, parameters: params)
        let prediction = predictions.max { $0.value < $1.value }!.key
        XCTAssertEqual(CampusAppView.grades, prediction)
    }
    
    func testNearbyEntitiesIntoOneLocationGroup() throws {
        let dataHandler = dataHandler(entities: nearbyEntities)
        let discretizedData = try dataHandler.getData()
        let locationGroups = Set(discretizedData.map { $0.location }).count
        XCTAssertEqual(1, locationGroups)
    }
    
    func testNearbyEntitiesIntoOneDateGroup() throws {
        let dataHandler = dataHandler(entities: nearbyEntities)
        let discretizedData = try dataHandler.getData()
        let dateGroups = Set(discretizedData.map { $0.date }).count
        XCTAssertEqual(1, dateGroups)
    }

    func testNearbyEntitiesIntoOneTimeGroup() throws {
        let dataHandler = dataHandler(entities: nearbyEntities)
        let discretizedData = try dataHandler.getData()
        let timeGroups = Set(discretizedData.map { $0.time }).count
        XCTAssertEqual(1, timeGroups)
    }
    
    func testDiverseEntitiesIntoSeparateLocationGroups() throws {
        let dataHandler = dataHandler(entities: diverseEntities)
        let discretizedData = try dataHandler.getData()
        let locationGroups = Set(discretizedData.map { $0.location }).count
        XCTAssertEqual(diverseEntities.count, locationGroups)
    }
    
    func testDiverseEntitiesIntoSeparateDateGroups() throws {
        let dataHandler = dataHandler(entities: diverseEntities)
        let discretizedData = try dataHandler.getData()
        let dateGroups = Set(discretizedData.map { $0.date }).count
        XCTAssertEqual(diverseEntities.count, dateGroups)
    }

    func testDiverseEntitiesIntoSeparateTimeGroups() throws {
        let dataHandler = dataHandler(entities: diverseEntities)
        let discretizedData = try dataHandler.getData()
        let timeGroups = Set(discretizedData.map { $0.time }).count
        XCTAssertEqual(diverseEntities.count, timeGroups)
    }

    private func dataHandler(entities: [AppUsageDataEntity]) -> AnalyticsDataHandler {
        return AnalyticsDataHandler(
            data: entities,
            locationGroupRadius: locationGroupRadius,
            timeNearbyThreshold: timeNearbyThreshold,
            dateNearbyThreshold: dateNearbyThreshold,
            minGroupSize: minGroupSize
        )
    }

}
