import Foundation
import MapKit

extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        var minLatitude: CLLocationDegrees = 90.0
        var maxLatitude: CLLocationDegrees = -90.0
        var minLongitude: CLLocationDegrees = 180.0
        var maxLongitude: CLLocationDegrees = -180.0

        for coordinate in coordinates {
            let latitude = Double(coordinate.latitude)
            let longitude = Double(coordinate.longitude)

            if latitude < minLatitude {
                minLatitude = latitude
            }
            if longitude < minLongitude {
                minLongitude = longitude
            }
            if latitude > maxLatitude {
                maxLatitude = latitude
            }
            if longitude > maxLongitude {
                maxLongitude = longitude
            }
        }

        let latitudeDelta = (maxLatitude - minLatitude) * 2.0
        let longitudeDelta = (maxLongitude - minLongitude) * 2.0
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let center = CLLocationCoordinate2D(latitude: maxLatitude - span.latitudeDelta / 4, longitude: maxLongitude - span.longitudeDelta / 4)
        self.init(center: center, span: span)
    }
}
