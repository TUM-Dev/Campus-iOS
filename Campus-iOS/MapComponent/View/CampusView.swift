//
//  CampusView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct CampusView: View {
    
    let campus: Campus
    let cafeterias: [Cafeteria]
    let studyRooms: [StudyRoomGroup]
    @StateObject var vm: MapViewModel
    @StateObject var vmNavi = NavigaTumViewModel()
    
    init(campus: Campus, cafeterias: [Cafeteria], studyRooms: [StudyRoomGroup], vm: MapViewModel) {
        self.campus = campus
        self.cafeterias = cafeterias
        self.studyRooms = studyRooms
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack {
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
                Label("Food", systemImage: "fork.knife").titleStyle()
                ForEach(cafeterias) { cafeteria in
                    CafeteriaViewNEW(cafeteria: cafeteria)
                    Divider().padding(.horizontal)
                }
                Label("Study Rooms", systemImage: "studentdesk").titleStyle()
                    .padding(.top, 20)
                ForEach(studyRooms) { studyRoom in
                    NavigationLink(destination: StudyRoomGroupView(
                        vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                        selectedGroup: studyRoom,
                        rooms: vm.studyRoomsResponse.rooms ?? [],
                        canDismiss: false
                    )) {
                        if let rooms =  studyRoom.getRooms(allRooms: vm.studyRoomsResponse.rooms ?? []){
                            Label {
                                HStack {
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
                            } icon: {
                                Image(systemName: "book").foregroundColor(Color.primaryText)
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal)
                        } else {
                            
                        }
                    }
                    .background(Color.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                    .padding(.horizontal)
                }
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
                                    Text(entry.name)
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Color.highlightText)
                                }
                                .padding(.horizontal)
                                .foregroundColor(Color.primaryText)
                                if entry != vmNavi.searchResults.last {
                                    Divider()
                                }
                            }
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
            .padding(.bottom, 20)
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .onAppear{
            Task {
                await getCampusRooms(String(self.campus.rawValue.dropFirst(2)))
            }
        }
    }
    
    func getCampusRooms(_ searchValue: String) async {
        await self.vmNavi.fetch(searchString: searchValue)
    }
}
