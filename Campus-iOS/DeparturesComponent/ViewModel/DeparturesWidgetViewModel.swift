//
//  DeparturesWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation
import Alamofire
import CoreLocation
import MapKit

@MainActor
class DeparturesWidgetViewModel: ObservableObject {
    
    @Published var departures = [Departure]()
    @Published var closestCampus: Campus?
    @Published var selectedStation: Station? {
        didSet {
            fetchDepartures()
            updatePreference()
        }
    }
    @Published var walkingDistance: Int?
    @Published var state: State
    
    private var locationManager = CLLocationManager()
    private let sessionManager = Session()
    
    var timer: Timer?
    
    init() {
        state = .loading
        Task {
            timer = Timer()
            calculateClosestCampus()
        }
    }
    
    func calculateClosestCampus() {
        guard let location = locationManager.location?.coordinate else {
            self.state = .noLocation
            return
        }
        let transposedLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let closestCampus = Campus.allCases.min(by: {
            transposedLocation.distance(from: $0.location) < transposedLocation.distance(from: $1.location)
        })
        
        self.closestCampus = closestCampus
        assignSelectedStation()
    }
    
    func assignSelectedStation() {
        if let closestCampus {
            let userDefaults = try? JSONDecoder().decode([Campus : Station].self, from: UserDefaults.standard.data(forKey: "departuresPreferences") ?? Data())
            if let userDefaults, let station = userDefaults[closestCampus] {
                self.selectedStation = station
            } else {
                self.selectedStation = closestCampus.defaultStation
            }
        }
    }
    
    @objc func fetchDepartures() {
        if closestCampus != nil {
            self.calculateWalkingDistance { (success) -> Void in
                if success {
                    self.makeRequest()
                }
            }
        }
    }
    
    func makeRequest() {
        if let closestCampus {
            if let selectedStation {
                sessionManager.cancelAllRequests()
                let request = sessionManager.request(MVVDeparturesAPI(station: selectedStation.apiName, walkingTime: self.walkingDistance))
                decodeRequest(request: request)
            } else {
                sessionManager.cancelAllRequests()
                let request = sessionManager.request(MVVDeparturesAPI(station: closestCampus.defaultStation.apiName, walkingTime: self.walkingDistance))
                decodeRequest(request: request)
            }
        }
    }
    
    private func decodeRequest(request: DataRequest) {
        request.responseDecodable(of: MVVRequest.self, decoder: JSONDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                self?.state = .failed
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
            self?.state = .success
            self?.setTimerForRefetch()
        }
    }
    
    func setTimerForRefetch() {
        if self.departures.count > 0 {
            timer = Timer.scheduledTimer(
                timeInterval: self.departures[0].countdown > 0 ? Double(self.departures[0].countdown) * 60.0 : 60.0,
                target: self,
                selector: #selector(fetchDepartures),
                userInfo: nil, repeats: false
            )
        }
    }
    
    func updatePreference() {
        if let selectedStation {
            let data = UserDefaults.standard.data(forKey: "departuresPreferences")
            if let closestCampus {
                if let data {
                    var preferences = try? JSONDecoder().decode([Campus : Station].self, from: data)
                    preferences?.updateValue(selectedStation, forKey: closestCampus)
                    let data = try? JSONEncoder().encode(preferences)
                    UserDefaults.standard.set(data, forKey: "departuresPreferences")
                } else {
                    let preferences: [Campus : Station] = [closestCampus : selectedStation]
                    let data = try? JSONEncoder().encode(preferences)
                    UserDefaults.standard.set(data, forKey: "departuresPreferences")
                }
            }
        }
    }
    
    func calculateWalkingDistance(completion: @escaping (_ success: Bool) -> Void) {
        if let currentLocation = locationManager.location?.coordinate, let selectedStation {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedStation.latitude, longitude: selectedStation.longitude)))
            request.transportType = .walking
            let directions = MKDirections(request: request)
            directions.calculateETA { (response, error) -> Void in
                guard let response = response else {
                    completion(self.walkingDistance != nil)
                    return
                }
                
                self.walkingDistance = (Int(response.expectedTravelTime) / 60) % 60
                completion(self.walkingDistance != nil)
            }
        }
    }
}

extension DeparturesWidgetViewModel {
    enum State {
        case loading
        case success
        case failed
        case noLocation
    }
}
