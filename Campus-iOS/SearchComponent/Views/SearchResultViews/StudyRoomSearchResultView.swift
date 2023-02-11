//
//  StudyRoomSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct StudyRoomSearchResultView: View {
    @StateObject var vm = StudyRoomSearchResultViewModel()
    @Binding var query: String
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.studyRoomResult) { result in
                    VStack {
                        Text(result.studyRoomResult.group.name ?? "no group name").foregroundColor(.indigo)
                        ScrollView {
                            ForEach(result.studyRoomResult.rooms) { room in
                                Text(room.name ?? "no room name").foregroundColor(.teal)
                                Text(room.localizedStatus).foregroundColor(.purple)
                            }
                        }.border(.red)
                    }
                }
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
