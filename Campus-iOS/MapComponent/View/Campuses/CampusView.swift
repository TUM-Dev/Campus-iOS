//
//  CampusView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct CampusView: View {
    
    let campus: Campus
    @StateObject var vm: MapViewModel
    @StateObject var vmNavi = NavigaTumViewModel()
    var vmAnno = AnnotatedMapViewModel()
    @State private var loadedRooms = false
    
    init(campus: Campus, cafeterias: [Cafeteria], studyRooms: [StudyRoomGroup]?, vm: MapViewModel) {
        self.campus = campus
        self._vm = StateObject(wrappedValue: vm)
        vmAnno.addCafeterias(cafeterias: cafeterias)
        if studyRooms != nil {
            vmAnno.addStudyRoomGroups(studyRoomGroups: studyRooms!)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group{
                    campus.image
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 120)
                        .clipped()
                        .padding([.horizontal,.top], 5)
                        .padding(.bottom, 10)
                    Text(campus.rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: Size.cardWidth, alignment: .leading)
                }
                
                CafeteriasListView(vm: self.vmAnno)
                
                StudyRoomGroupListView(vmAnno: self.vmAnno, vm: self.vm)
                
                RoomsView(vm: self.vmAnno)
                
                AnnotatedMapView(vm: vmAnno, centerOfMap: campus.location.coordinate, zoomLevel: 0.01)
                
            }
            .padding(.bottom, 20)
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .task {
            if !loadedRooms {
                await getCampusRooms(self.campus.searchStringRooms)
                await vmAnno.addRooms(rooms: vmNavi.searchResults.filter({$0.name.first?.isNumber ?? false})) //clean up
                loadedRooms = true
            }
        }
    }
    
    func getCampusRooms(_ searchValue: String) async {
        await self.vmNavi.fetch(searchString: searchValue)
    }
    
}
