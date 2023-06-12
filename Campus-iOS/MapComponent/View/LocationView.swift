//
//  LocationView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.06.23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    var location: TUMLocation
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.1372, longitude: 11.5755), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
    
    var body: some View {
        ScrollView {
            VStack {
                Text(location.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: Size.cardWidth, alignment: .leading)
                
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [self.location]) {
                    MapAnnotation(coordinate: $0.coordinate) {
                        VStack(spacing: 0) {
                            location.symbol
                                .resizable()
                                .foregroundColor(Color.highlightText)
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .foregroundColor(Color.highlightText)
                                .offset(x: 0, y: -2)
                        }
                        .offset(x: 0, y: -18)
                    }
                }
                .frame(width: Size.cardWidth, height: Size.cardWidth)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                
                Button(action: {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                    
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }, label: {
                    Text("Directions in Maps \(Image(systemName: "arrow.triangle.turn.up.right.diamond"))")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: Size.cardWidth)
                        .background(Color.highlightText)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                })
                
                Divider().padding()
                
                if location.cafeteria != nil {
                    CafeteriaView(cafeteria: location.cafeteria!, onlyMenu: true)
                        .padding(.bottom)
                }
                
                if location.room != nil {
                    RoomDetailsView(room: location.room!, details: location.roomDetails!)
                        .padding(.bottom)
                }
                
                HStack{
                    Spacer()
                    Spacer()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .onAppear {
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
        }
    }
}
