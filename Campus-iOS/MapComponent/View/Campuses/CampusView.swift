//
//  CampusView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI
import MapKit

struct CampusView: View {
    
    let campus: Campus
    let cafeterias: [Cafeteria]
    let studyRooms: [StudyRoomGroup]?
    @StateObject var vm: MapViewModel
    @StateObject var vmNavi = NavigaTumViewModel()
    @State private var region: MKCoordinateRegion
    @State private var pointsOfInterest = [AnnotatedItem]()
    
    init(campus: Campus, cafeterias: [Cafeteria], studyRooms: [StudyRoomGroup]?, vm: MapViewModel) {
        self.campus = campus
        self.cafeterias = cafeterias
        self.studyRooms = studyRooms
        self._vm = StateObject(wrappedValue: vm)
        self.region = MKCoordinateRegion(center: campus.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
                        .padding(.bottom, 20)
                }
                if !cafeterias.isEmpty {
                    Group{
                        Label("Food", systemImage: "fork.knife").titleStyle()
                        ForEach(cafeterias) { cafeteria in
                            CafeteriaViewNEW(cafeteria: cafeteria)
                                .task {
                                    self.pointsOfInterest.append(AnnotatedItem(name: cafeteria.name, coordinate: cafeteria.coordinate, symbol: Image(systemName: "fork.knife.circle.fill")))
                                }
                            Divider().padding(.horizontal)
                        }
                    }
                }
                
                if let studyGroups = self.studyRooms {
                    if !studyGroups.isEmpty {
                        Group {
                            Label("Study Rooms", systemImage: "studentdesk").titleStyle()
                                .padding(.top, 20)
                            VStack {
                                ForEach(studyGroups) { studyRoom in
                                    NavigationLink(destination: StudyRoomGroupView(
                                        vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                                        selectedGroup: studyRoom,
                                        rooms: vm.studyRoomsResponse.rooms ?? [],
                                        canDismiss: false
                                    )) {
                                        if let rooms =  studyRoom.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? []){
                                            
                                            VStack {
                                                HStack {
                                                    Image(systemName: "pencil.circle")
                                                        .resizable()
                                                        .foregroundColor(Color.highlightText)
                                                        .frame(width: 20, height: 20)
                                                        .clipShape(Circle())
                                                    Text(studyRoom.name!).foregroundColor(Color.primaryText)
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
                                                if studyRoom != studyGroups.last {
                                                    Divider()
                                                }
                                            }
                                            
                                            .task {
                                                self.pointsOfInterest.append(AnnotatedItem(name: studyRoom.name!, coordinate: studyRoom.coordinate!, symbol: Image(systemName: "pencil.circle.fill")))
                                            }
                                        } else {
                                            
                                        }
                                    }
                                }
                            }
                            .sectionStyle()
                        }
                    }
                }
                
                if !vmNavi.searchResults.filter({$0.name.first?.isNumber ?? false}).isEmpty {
                    Group {
                        Label("Most Searched Rooms", systemImage: "door.right.hand.closed").titleStyle()
                            .padding(.top, 20)
                        
                        VStack {
                            ForEach(vmNavi.searchResults.filter{$0.name.first?.isNumber ?? false
                            }) { entry in
                                NavigationLink(
                                    destination: NavigaTumDetailsView(viewModel: NavigaTumDetailsViewModel(id: entry.id))
                                ) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "graduationcap.circle")
                                                .resizable()
                                                .foregroundColor(Color.highlightText)
                                                .frame(width: 20, height: 20)
                                                .clipShape(Circle())
                                            Text(entry.name)
                                            Spacer()
                                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                                        }
                                        .padding(.horizontal, 5)
                                        .foregroundColor(Color.primaryText)
                                        if entry != vmNavi.searchResults.last {
                                            Divider()
                                        }
                                    }
                                }
                                .task {
                                    let tempVm = NavigaTumDetailsViewModel(id: entry.id)
                                    await tempVm.fetchDetails()
                                    self.pointsOfInterest.append(AnnotatedItem(name: entry.name, coordinate: CLLocationCoordinate2D(latitude: tempVm.details?.coordinates.latitude ?? 0, longitude: tempVm.details?.coordinates.longitude ?? 0), symbol: Image(systemName: "graduationcap.circle.fill")))
                                }
                            }
                        }
                        .sectionStyle()
                        if vmNavi.errorMessage != "" {
                            VStack {
                                Spacer()
                                Text(self.vmNavi.errorMessage).foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                }
                
                
                Group {
                    Label("View On Maps", systemImage: "map").titleStyle()
                        .padding(.top, 20)
                    
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pointsOfInterest) {item in
                        MapAnnotation(coordinate: item.coordinate) {
                            PlaceAnnotationView(item: item)
                        }
                    }
                    .frame(width: Size.cardWidth, height: Size.cardWidth)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                }
            }
            .padding(.bottom, 20)
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .onAppear{
            Task {
                await getCampusRooms(self.campus.searchStringRooms)
            }
        }
    }
    
    func getCampusRooms(_ searchValue: String) async {
        await self.vmNavi.fetch(searchString: searchValue)
    }
    
}
