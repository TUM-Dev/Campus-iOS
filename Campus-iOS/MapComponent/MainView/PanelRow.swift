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
    
    @Binding var cafeteria: Cafeteria
    @State var explainStatus = false
    private let locationManager = CLLocationManager()
    private let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer().frame(height: 5)
                    HStack {
                        Text(cafeteria.name)
                            .bold()
                            .font(.title3)
                        Spacer()
                        if let queue = cafeteria.queue {
                            let explainText = explainStatus ? "Auslastung " : ""
                            Text("\(explainText)\(Int(queue.percent))%")
                                .font(.footnote)
                                .onTapGesture {
                                    explainStatus.toggle()
                                }
                        }
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

struct PanelRow_Previews: PreviewProvider {
    static var previews: some View {
        PanelRow(cafeteria: .constant(Cafeteria(location: Location(latitude: 0.0,
                                                                   longitude: 0.0,
                                                                   address: ""),
                                                name: "",
                                                id: "",
                                                queueStatusApi: "")))
    }
}
