//
//  RoomFinderMapViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import Foundation
import MapKit

class RoomFinderMapViewModel: ObservableObject {
    @Published var location : CLLocationCoordinate2D?
    @Published var errorConvertingAddress = false
        
    func convertAddress(address: String) {
        getCoordinate(addressString: address) { (location, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.errorConvertingAddress = true
                }
                return
            }
            DispatchQueue.main.async {
                self.location = location
            }
        }
    }
    
    private func getCoordinate(addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
