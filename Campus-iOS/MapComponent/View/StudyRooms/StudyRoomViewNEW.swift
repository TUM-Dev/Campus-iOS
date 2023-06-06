//
//  StudyRoomViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct StudyRoomViewNEW: View {
    
    @StateObject var vm: MapViewModel
    let studyRoomGroups: [StudyRoomGroup]?
    @State private var pointsOfInterest = [AnnotatedItem]()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.1372, longitude: 11.5755), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    
    init(vm: MapViewModel, studyRoomGroups: [StudyRoomGroup]? = nil) {
        self._vm = StateObject(wrappedValue: vm)
        self.studyRoomGroups = studyRoomGroups
    }
    
    var body: some View {
        if let loadedStudyRoomsGroups = studyRoomGroups {
            ScrollView {
                VStack {
                    Label("View On Maps", systemImage: "map").titleStyle()
                        .padding(.top, 20)
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pointsOfInterest) {item in
                        MapAnnotation(coordinate: item.coordinate) {
                            PlaceAnnotationView(symbol: item.symbol)
                        }
                    }
                    .frame(width: Size.cardWidth, height: Size.cardWidth)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                    
                    Label("Study Rooms", systemImage: "studentdesk").titleStyle()
                        .padding(.top, 20)
                    
                    VStack {
                        ForEach(loadedStudyRoomsGroups) { studyRoomGroup in
                            NavigationLink(destination: StudyRoomGroupViewOld(
                                vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                                selectedGroup: studyRoomGroup,
                                rooms: vm.studyRoomsResponse.rooms ?? [],
                                canDismiss: false
                            )) {
                                if let rooms =  studyRoomGroup.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? []){
                                    
                                    VStack {
                                        HStack {
                                            Image(systemName: "pencil.circle")
                                                .resizable()
                                                .foregroundColor(Color.highlightText)
                                                .frame(width: 20, height: 20)
                                                .clipShape(Circle())
                                            Text(studyRoomGroup.name!).foregroundColor(Color.primaryText)
                                            let freeRooms = rooms.filter{ $0.isAvailable() }.count
                                            if freeRooms > 0 {
                                                Spacer()
                                                Text("\(freeRooms) rooms free").foregroundColor(.green)
                                            } else {
                                                Spacer()
                                                Text("No rooms free").foregroundColor(.red)
                                            }
                                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                                        }
                                        .padding(.horizontal, 5)
                                        if studyRoomGroup != loadedStudyRoomsGroups.last {
                                            Divider()
                                        }
                                    }
                                    
                                    .task {
                                        self.pointsOfInterest.append(AnnotatedItem(name: studyRoomGroup.name!, coordinate: studyRoomGroup.coordinate!, symbol: Image(systemName: "pencil.circle.fill")))
                                    }
                                } else {
                                    
                                }
                            }
                        }
                    }
                    .sectionStyle()
                }
                .padding(.bottom, 20)
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
        }
    }
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var name: String
        var coordinate: CLLocationCoordinate2D
        var symbol: Image
    }
    
    struct PlaceAnnotationView: View {
        var symbol: Image
        var body: some View {
            VStack(spacing: 0) {
                symbol
                    .resizable()
                    .foregroundColor(Color.highlightText)
                    .frame(width: 20, height: 20)
                    .background(.white)
                    .clipShape(Circle())
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(Color.highlightText)
                    .offset(x: 0, y: -5)
            }
        }
    }
}
