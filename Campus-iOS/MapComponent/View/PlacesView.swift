//
//  PlacesView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct PlacesView: View {
    @StateObject var vm: MapViewModel
    @State var sortedCafeterias: [Cafeteria]
    
    var locationManager = CLLocationManager()
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        if let location = self.locationManager.location {
            self.sortedCafeterias = vm.cafeterias.sorted {
                $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
            }
        } else {
            self.sortedCafeterias = vm.cafeterias
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: CafeteriaViewNEW(vm: self.vm).navigationBarTitle(Text("Cafeterias"))) {
                    Label {
                        HStack {
                            Text("Cafeterias").foregroundColor(Color.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "fork.knife").foregroundColor(Color.primaryText)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom, 10)
                
                NavigationLink(destination: StudyRoomViewNEW().navigationBarTitle(Text("Study Rooms"))) {
                    Label {
                        HStack {
                            Text("Study Rooms").foregroundColor(Color.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "studentdesk").foregroundColor(Color.primaryText)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.stammgelaende)) {
                    CampusCellView(campus: Campus.stammgelaende)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.garching)) {
                    CampusCellView(campus: Campus.garching)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.freising)) {
                    CampusCellView(campus: Campus.freising)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.klinikumRechts)) {
                    CampusCellView(campus: Campus.klinikumRechts)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.olympiapark)) {
                    CampusCellView(campus: Campus.olympiapark)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

