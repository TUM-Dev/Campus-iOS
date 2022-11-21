//
//  PanelContentStudyGroupsListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 11.06.22.
//

import SwiftUI
import MapKit

struct PanelContentStudyGroupsListView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @Binding var searchString: String
    
    @State var sortedGroups: [StudyRoomGroupCoreData]
    
    var locationManager = CLLocationManager()
    
    init(viewModel vm: MapViewModel, searchString text: Binding<String>) {
        self.viewModel = vm
        self._searchString = text
        if let location = self.locationManager.location {
            self.sortedGroups = vm.studyRoomGroups.sorted {
                if let lhs = $0.coordinate, let rhs = $1.coordinate {
                    return lhs.location.distance(from: location) < rhs.location.distance(from: location)
                } else {
                    return false
                }
            }
        } else {
            self.sortedGroups = vm.studyRoomGroups
        }
    }
    
    var body: some View {
        List {
            ForEach (sortedGroups.indices.filter({ searchString.isEmpty ? true : sortedGroups[$0].name?.localizedCaseInsensitiveContains(searchString) ?? false }), id: \.self) { id in
                Button(action: {
                    viewModel.selectedStudyGroup = sortedGroups[id]
                    viewModel.panelPos = .middle
                    viewModel.lockPanel = false
                }, label: {
                    StudyGroupRowView(
                        studyGroup: sortedGroups[id],
                        allRooms: viewModel.studyRooms
                    )
                })
            }
        }
        .searchable(text: $searchString, prompt: "Look for something")
        .listStyle(PlainListStyle())
    }
}

struct PanelContentStudyGroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        PanelContentStudyGroupsListView(viewModel: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()), searchString: .constant(""))
    }
}
