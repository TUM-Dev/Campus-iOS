//
//  StudyGroupRow.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 22.05.22.
//

import SwiftUI
import MapKit

struct StudyGroupRowView: View {
    
    @State var studyGroup: StudyRoomGroup
    @State var allRooms: [StudyRoom]
    @State var explainStatus = false
    private let locationManager = CLLocationManager()
    private let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    private var studyRooms: [StudyRoom] {
        self.studyGroup.getRooms(allRooms: allRooms) ?? [StudyRoom]()
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer().frame(height: 5)
                    HStack {
                        Text(studyGroup.name ?? "")
                            .bold()
                            .font(.title3)
                        Spacer()
                        Text("\(studyRooms.count)")
                            .font(.footnote)
                            .onTapGesture {
                                explainStatus.toggle()
                            }
                    }
                    Spacer().frame(height: 0)
                    HStack {
                        Text(studyGroup.detail ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(distance(studyGroup: studyGroup))
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    Spacer().frame(height: 0)
                }
            }
        }
    }
    
    private func distance(studyGroup: StudyRoomGroup) -> String {
        if let currentLocation = self.locationManager.location {
            let distance = studyGroup.coordinate?.location.distance(from: currentLocation) ?? 0.0
            return distanceFormatter.string(fromDistance: distance)
        }
        return ""
    }
}

struct StudyGroupRowView_Previews: PreviewProvider {
    static var previews: some View {
        StudyGroupRowView(studyGroup: StudyRoomGroup(), allRooms: [StudyRoom]())
    }
}
