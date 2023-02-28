//
//  DeparturesDetailsView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesDetailsView: View {
    
    @StateObject var departuresViewModel: DepaturesWidgetViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: header) {
                    if departuresViewModel.departures.count > 0 {
                        ForEach(self.departuresViewModel.departures, id: \.self) { departure in
                            DeparturesDetailsRowView(departuresViewModel: departuresViewModel, departure: departure)
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
    }
    
    var header: some View {
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
        DeparturesDetailsView(departuresViewModel: DepaturesWidgetViewModel())
    }
}
