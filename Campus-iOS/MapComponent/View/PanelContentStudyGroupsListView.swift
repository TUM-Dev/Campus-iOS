//
//  PanelContentStudyGroupsListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 11.06.22.
//

import SwiftUI
import MapKit

struct PanelContentStudyGroupsListView: View {
    
    @StateObject var viewModel: MapViewModel
    @Binding var searchString: String
    
    var locationManager = CLLocationManager()
    
    init(viewModel vm: MapViewModel, searchString text: Binding<String>) {
        self._viewModel = StateObject(wrappedValue: vm)
        self._searchString = text
    }
    
    var body: some View {
        List {
            ForEach (viewModel.studyRoomGroups.sorted(by: {
                if let location = self.locationManager.location {
                    if let lhs = $0.coordinate, let rhs = $1.coordinate {
                        return lhs.location.distance(from: location) < rhs.location.distance(from: location)
                    } else {
                        return false
                    }
                } else {
                    return false
            }
            }).indices.filter({ searchString.isEmpty ? true : viewModel.studyRoomGroups[$0].name?.localizedCaseInsensitiveContains(searchString) ?? false }), id: \.self) { id in
                Button(action: {
                    viewModel.selectedStudyGroup = viewModel.studyRoomGroups[id]
                    viewModel.panelPos = .middle
                    viewModel.lockPanel = false
                }, label: {
                    StudyGroupRowView(
                        studyGroup: viewModel.studyRoomGroups[id],
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
        PanelContentStudyGroupsListView(viewModel: MapViewModel(context: PersistenceController.shared.container.viewContext, cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()), searchString: .constant(""))
    }
}
