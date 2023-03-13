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
    
    // TODO: replace with Timothy's Theme
    let cardWidth = UIScreen.main.bounds.size.width * 0.9
    
    var body: some View {
        VStack(spacing: 0) {
            title
            Button {
                showDetailsSheet = true
            } label: {
                contentRouter()
                    .frame(height: 140)
                // TODO: replace with Timothy's styles
                    .padding()
                    .frame(width: cardWidth)
                    .background(Color("secondaryBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }.sheet(isPresented: $showDetailsSheet) {
                DeparturesDetailsView(departuresViewModel: departuresViewModel)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.bottom)
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
        if let closestCampus = departuresViewModel.closestCampus,
           let selectedStation = departuresViewModel.selectedStation {
            VStack(alignment: .leading) {
                Group {
                    Text("\(selectedStation.name) @ \(closestCampus.rawValue)")
                        .foregroundColor(.tumBlue)
                    if let walkingDistance = departuresViewModel.walkingDistance {
                        Text("Walking Distance")
                        + Text(": ")
                        + Text("\(walkingDistance) \(walkingDistance > 1 ? "mins" : "min")")
                            .foregroundColor(.tumBlue)
                    }
                }
                ForEach(Array(departuresViewModel.departures.prefix(3)), id: \.self) { departure in
                    DeparturesDetailsRowView(
                        departuresViewModel: departuresViewModel,
                        departure: departure
                    )
                }
            }
            .font(.caption)
        }
    }
    
    // TODO: replace with Timothy's styles
    var title: some View {
        HStack {
            Text("MVV Departures")
                .font(.headline.bold())
                .foregroundColor(.tumBlue)
            Spacer()
        }
        .padding(.leading)
        .padding(.bottom, 10)
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
