//
//  PlacesView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct PlacesView: View {
    @StateObject var vm: MapViewModel
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: CafeteriasView(vm: self.vm).navigationBarTitle(Text("Cafeterias"))) {
                    Label {
                        HStack {
                            Text("Cafeterias").foregroundColor(Color.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "fork.knife").foregroundColor(Color.primaryText)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom, 10)
                
                NavigationLink(destination: StudyRoomGroupsView(vm: self.vm, studyRoomGroups: self.vm.studyRoomsResponse.groups).navigationBarTitle(Text("Study Rooms"))) {
                    Label {
                        HStack {
                            Text("Study Rooms").foregroundColor(Color.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "studentdesk").foregroundColor(Color.primaryText)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.stammgelaende, cafeterias: self.vm.getCampusCafeteria(campus: Campus.stammgelaende), studyRooms: self.vm.getCampusStudyRooms(campus: Campus.stammgelaende), vm: self.vm)) {
                    CampusCellView(campus: Campus.stammgelaende)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.garching, cafeterias: self.vm.getCampusCafeteria(campus: Campus.garching), studyRooms: self.vm.getCampusStudyRooms(campus: Campus.garching), vm: self.vm)) {
                    CampusCellView(campus: Campus.garching)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.freising, cafeterias: self.vm.getCampusCafeteria(campus: Campus.freising), studyRooms: self.vm.getCampusStudyRooms(campus: Campus.freising), vm: self.vm)) {
                    CampusCellView(campus: Campus.freising)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.klinikumRechts, cafeterias: self.vm.getCampusCafeteria(campus: Campus.klinikumRechts), studyRooms: self.vm.getCampusStudyRooms(campus: Campus.klinikumRechts), vm: self.vm)) {
                    CampusCellView(campus: Campus.klinikumRechts)
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: CampusView(campus: Campus.olympiapark, cafeterias: self.vm.getCampusCafeteria(campus: Campus.olympiapark), studyRooms: self.vm.getCampusStudyRooms(campus: Campus.olympiapark), vm: self.vm)) {
                    CampusCellView(campus: Campus.olympiapark)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

