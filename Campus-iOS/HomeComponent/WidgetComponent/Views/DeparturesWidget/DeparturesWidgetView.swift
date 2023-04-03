//
//  DeparturesWidgetView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesWidgetView: View {
    
    @StateObject var departuresViewModel: DeparturesWidgetViewModel
    @Binding var showDetailsSheet: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if let campusName = departuresViewModel.closestCampus?.rawValue {
                Text("Departures @ \(campusName)")
                    .titleStyle()
                    .lineLimit(1)
            } else {
                Text("MVV Departures")
            }
            Button {
                showDetailsSheet = true
            } label: {
                contentRouter()
                    .frame(height: 160)
                    .sectionStyle()
            }.sheet(isPresented: $showDetailsSheet) {
                DeparturesDetailsView(departuresViewModel: departuresViewModel)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder
    func contentRouter() -> some View {
        switch departuresViewModel.state {
        case .loading:
            WidgetLoadingView(text: "fetching latest departures")
                .font(.caption)
        case .failed:
            Text("no departures where found for this station")
                .font(.caption)
        case .success:
            content()
        case .noLocation:
            Text("location currently unavailable")
                .font(.caption)
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        if departuresViewModel.closestCampus != nil,
           let selectedStation = departuresViewModel.selectedStation {
            VStack(alignment: .leading) {
                Group {
                    Text("Station")
                    + Text(": ")
                    + Text(selectedStation.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.highlightText)
                    if let walkingDistance = departuresViewModel.walkingDistance {
                        Text("Walking Distance")
                        + Text(": ")
                        + Text("\(walkingDistance) \(walkingDistance > 1 ? "mins" : "min")")
                            .foregroundColor(.highlightText)
                            .fontWeight(.semibold)
                    }
                }
                ForEach(Array(departuresViewModel.departures.prefix(3)), id: \.self) { departure in
                    DeparturesDetailsRowView(
                        departuresViewModel: departuresViewModel,
                        departure: departure
                    )
                }
            }
            .font(.callout)
        }
    }
}

struct DeparturesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesWidgetView(
            departuresViewModel: DeparturesWidgetViewModel(),
            showDetailsSheet: .constant(false)
        )
    }
}
