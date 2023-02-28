//
//  DeparturesWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation
import Alamofire
import CoreLocation

@MainActor
class DepaturesWidgetViewModel: ObservableObject {
    
    @Published var departures = [Departure]()
    @Published var closestCampus: Campus?
    
    private var locationManager = CLLocationManager()
    private let sessionManager = Session.defaultSession
    
    init() {
        calculateClosestCampus()
        fetchDepartures()
    }
    
    func calculateClosestCampus() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let transposedLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let closestCampus = Campus.allCases.min(by: {
            transposedLocation.distance(from: $0.location) < transposedLocation.distance(from: $1.location)
        })
        
        self.closestCampus = closestCampus
    }
    
    func fetchDepartures() {
        if let closestCampus {
            sessionManager.cancelAllRequests()
            let request = sessionManager.request(MVVDeparturesAPI(station: closestCampus.defaultStation.apiName))
            decodeRequest(request: request)
        }
    }
    
    private func decodeRequest(request: DataRequest) {
        request.responseDecodable(of: MVVRequest.self, decoder: JSONDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                return
            }
            
            self?.departures = response.value?.departures
                .sorted(by: {
                    if let realTimeData1 = $0.realDateTime, let realTimeData2 = $1.realDateTime {
                        if realTimeData1.hour != realTimeData2.hour {
                            return realTimeData1.hour < realTimeData2.hour
                        } else {
                            return realTimeData1.minute < realTimeData2.minute
                        }
                    } else if let realTimeData1 = $0.realDateTime {
                        if realTimeData1.hour != $1.dateTime.hour {
                            return realTimeData1.hour < $1.dateTime.hour
                        } else {
                            return realTimeData1.minute < $1.dateTime.minute
                        }
                    } else if let realTimeData2 = $1.realDateTime {
                        if $0.dateTime.hour != realTimeData2.hour {
                            return $0.dateTime.hour < realTimeData2.hour
                        } else {
                            return $0.dateTime.minute < realTimeData2.minute
                        }
                    } else {
                        if $0.dateTime.hour != $1.dateTime.hour {
                            return $0.dateTime.hour < $1.dateTime.hour
                        } else {
                            return $0.dateTime.minute < $1.dateTime.minute
                        }
                    }
                }) ?? []
        }
    }
}
