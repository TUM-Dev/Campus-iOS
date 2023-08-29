//
//  StudyRoomViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct StudyRoomGroupsView: View {
    
    @StateObject var vm: MapViewModel
    var vmAnno = AnnotatedMapViewModel()
    
    init(vm: MapViewModel, studyRoomGroups: [StudyRoomGroup]? = nil) {
        self._vm = StateObject(wrappedValue: vm)
        if (studyRoomGroups != nil) {
            vmAnno.addStudyRoomGroups(studyRoomGroups: studyRoomGroups!)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                AnnotatedMapView(vm: vmAnno, centerOfMap: CLLocationCoordinate2D(latitude: 48.1372, longitude: 11.5755), zoomLevel: 0.3)
                
                StudyRoomGroupListView(vmAnno: self.vmAnno, vm: self.vm)
                
            }
            .padding(.bottom, 20)
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
}
