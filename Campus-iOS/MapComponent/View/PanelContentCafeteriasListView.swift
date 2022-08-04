//
//  PanelContentListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 10.06.22.
//

import SwiftUI
import MapKit

struct PanelContentCafeteriasListView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @Binding var searchString: String
    
    @State var sortedCafeterias: [Cafeteria]
    
    var locationManager = CLLocationManager()
    
    init(viewModel vm: MapViewModel, searchString text: Binding<String>) {
        self.viewModel = vm
        self._searchString = text
        if let location = self.locationManager.location {
            self.sortedCafeterias = vm.cafeterias.sorted {
                $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
            }
        } else {
            self.sortedCafeterias = vm.cafeterias
        }
    }
    
    var body: some View {
        List {
            ForEach (self.sortedCafeterias.indices.filter({ searchString.isEmpty ? true : self.sortedCafeterias[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                Button(action: {
                    //print("BEFORE: \(viewModel.selectedCafeteria)")
                    viewModel.selectedCafeteria = self.sortedCafeterias[id]
                    viewModel.panelPos = .middle
                    viewModel.lockPanel = false
                    //print("AFTER: \(viewModel.selectedCafeteria)")
                }, label: {
                    CafeteriaRowView(cafeteria: self.$sortedCafeterias[id])
                })
            }
        }
        .searchable(text: $searchString, prompt: "Look for something")
        .listStyle(PlainListStyle())
    }
}

struct PanelContentCafeteriasListView_Previews: PreviewProvider {
    static var previews: some View {
        PanelContentCafeteriasListView(viewModel: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()), searchString: .constant(""))
    }
}
