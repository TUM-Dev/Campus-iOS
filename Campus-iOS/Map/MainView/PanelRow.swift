//
//  PanelRow.swift
//  Campus-iOS
//
//  Created by Tim Gymnich on 20.01.22.
//

import SwiftUI
import CoreLocation
import MapKit

struct PanelRow: View {
    
    @State var cafeteria: Cafeteria
    private let locationManager = CLLocationManager()
    private let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
<<<<<<< HEAD
                VStack(alignment: .leading, spacing: 5) {
=======
                VStack(alignment: .leading, spacing: 8) {
>>>>>>> 01b55bc (Draft some kind of viewmodel (#396))
                    Spacer().frame(height: 5)
                    HStack {
                        Text(cafeteria.name)
                            .bold()
                            .font(.title3)
                    }
                    Spacer().frame(height: 0)
                    HStack {
                        Text(cafeteria.location.address)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(distance(cafeteria: cafeteria))
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    Spacer().frame(height: 0)
                }
            }
        }
    }
    
    private func distance(cafeteria: Cafeteria) -> String {
        if let currentLocation = self.locationManager.location {
            let distance = cafeteria.coordinate.location.distance(from: currentLocation)
            return distanceFormatter.string(fromDistance: distance)
        }
        return ""
    }
}

//
//struct PanelRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelRow()
//    }
//}
