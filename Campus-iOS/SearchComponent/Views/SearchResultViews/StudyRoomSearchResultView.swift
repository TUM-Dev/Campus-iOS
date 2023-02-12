//
//  StudyRoomSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct StudyRoomSearchResultView: View {
    @StateObject var vm: StudyRoomSearchResultViewModel
    @Binding var query: String
    @State var showRoomsForGroup: [StudyRoom]? = nil
    @State var size: ResultSize = .small
    
    var results: [(studyRoomResult: StudyRoomSearchResult, distance: Distances)] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                VStack {
                    ZStack {
                        Text("Study Rooms")
                            .fontWeight(.bold)
                            .font(.title)
                        HStack {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
                                        self.size = .big
                                    }
                                }
                            } label: {
                                if self.size == .small {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                } else {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                ScrollView {
                    ForEach(vm.results, id: \.studyRoomResult) { result in
                        VStack (alignment: .leading) {
                            HStack {
                                Text(result.studyRoomResult.group.name ?? "no group name")
                                    .fontWeight(.heavy)
                                Spacer()
                                GroupDirectionsButton(group: result.studyRoomResult.group) {
                                    Image(systemName: "mappin.and.ellipse")
                                }
                            }
                            Button {
                                withAnimation {
                                    self.showRoomsForGroup = showRoomsForGroup == result.studyRoomResult.rooms ? nil : result.studyRoomResult.rooms
                                }
                            } label: {
                                if showRoomsForGroup == result.studyRoomResult.rooms {
                                    Text("Hide rooms")
                                        .foregroundColor(.gray)
                                        .fontWeight(.light)
                                } else {
                                    Text("Show rooms")
                                        .foregroundColor(.gray)
                                        .fontWeight(.light)
                                }
                            }

                            
                            if let rooms = showRoomsForGroup, showRoomsForGroup == result.studyRoomResult.rooms {
                                ForEach(rooms) { room in
                                    StudyRoomCell(room: room)
                                        .tint(.black)
//                                    Text(room.name ?? "no room name").foregroundColor(.teal)
//                                    Text(room.localizedStatus).foregroundColor(.purple)
                                }
                            }
                        }
                    }
                }.padding()
            }
        }.onChange(of: query) { newQuery in
            Task {
                
                await vm.studyRoomSearch(for: newQuery)
            }
        }.onAppear() {
            Task {
                await vm.studyRoomSearch(for: query)
            }
        }
    }
}

struct StudyRoomSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomSearchResultView(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: .constant("studyroom garching"))
    }
}

struct StudyRoomsService_Preview: StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        return StudyRoomApiRespose.previewData
    }
}
