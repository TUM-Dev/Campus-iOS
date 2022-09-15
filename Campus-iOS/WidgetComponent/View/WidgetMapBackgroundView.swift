//
//  WidgetMapBackgroundView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 17.07.22.
//

import SwiftUI
import MapKit

struct WidgetMapBackgroundView: View {
    
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude - 0.03
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        Map(coordinateRegion: Binding.constant(region),
            annotationItems: [MapLocation(coordinate: coordinate)]) { item in
                MapMarker(coordinate: item.coordinate)
            }
            .blur(radius: 2)
            .allowsHitTesting(false) // Disallow map interaction.
            .overlay {
                Rectangle().foregroundColor(.widget.opacity(0.9))
            }
    }
}

struct WidgetMapBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMapBackgroundView(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42))
    }
}
