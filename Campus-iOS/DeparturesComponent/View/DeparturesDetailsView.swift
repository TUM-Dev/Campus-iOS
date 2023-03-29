//
//  DeparturesDetailsView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesDetailsView: View {
    
    @StateObject var departuresViewModel: DeparturesWidgetViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: header) {
                    if departuresViewModel.departures.count > 0 {
                        ForEach(self.departuresViewModel.departures, id: \.self) { departure in
                            DeparturesDetailsRowView(departuresViewModel: departuresViewModel, departure: departure)
                                .font(.callout)
                        }
                    } else {
                        Text("no departures where found for this station")
                            .font(.callout)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(departuresViewModel.closestCampus?.rawValue ?? "Departures")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbar()
            }
            .refreshable {
                departuresViewModel.fetchDepartures()
            }
        }
    }
    
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: {
                dismiss()
            })
        }
        ToolbarItem(placement: .navigationBarLeading) {
            stationMenu
        }
    }
    
    var stationMenu: some View {
        Menu (
            content: {
                Picker("Station", selection: $departuresViewModel.selectedStation) {
                    ForEach(departuresViewModel.closestCampus?.allStations ?? [], id: \.self) { station in
                        Text(station.name)
                            .tag(station as Station?)
                    }
                }
            },
            label: { Image(systemName: "house.and.flag") }
        )
    }
    
    var header: some View {
        VStack {
            if let selectedStation = departuresViewModel.selectedStation {
                VStack(alignment: .leading) {
                    currentStationText(selectedStation.name)
                    walkingDistanceDirections(selectedStation)
                }
            }
            listLegend
        }
    }
    
    func currentStationText(_ name: String) -> some View {
        Group {
            Text("Station: ")
            + Text(name)
                .foregroundColor(.blue)
        }
        .font(.footnote)
        .fontWeight(.semibold)
    }
    
    func walkingDistanceDirections(_ selectedStation: Station) -> some View {
        HStack {
            Group {
                directionsText()
                Spacer()
                directionsButton(selectedStation)
            }
            .font(.footnote)
        }
        .padding(.bottom, 1)
    }
    
    @ViewBuilder
    func directionsText() -> some View {
        if let walkingDistance = departuresViewModel.walkingDistance {
            Text("Walking Distance")
                .fontWeight(.semibold)
            + Text(": ")
            + Text(walkingDistance.description)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            + Text(" \(walkingDistance > 1 ? "mins" : "min")")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        } else {
            Text("walking distance currently unavailable")
        }
    }
    
    func directionsButton(_ selectedStation: Station) -> some View {
        Button(action: {
            let latitude = selectedStation.latitude
            let longitude = selectedStation.longitude
            let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)&dirflg=w")
            
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }, label: {
            Label("Show Directions", systemImage: "arrow.right.circle")
                .labelStyle(TrailingIconLabelStyle())
        })
    }
    
    var listLegend: some View {
        HStack {
            Text("Line")
                .frame(width: 50, alignment: .leading)
                .padding(.trailing)
            Text("Direction")
            Spacer()
            Text("Departure")
        }
        .font(.callout)
        .fontWeight(.semibold)
    }
}

struct DeparturesDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesDetailsView(departuresViewModel: DeparturesWidgetViewModel())
    }
}
