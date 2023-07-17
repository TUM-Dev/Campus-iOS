//
//  SwiftUIView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct StudyRoomSearchResultScreen: View {
    @StateObject var vm: StudyRoomSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                StudyRoomSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "StudyRooms")
            case .failed(let error):
                SearchResultErrorView(title: "StudyRooms", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                
                await vm.studyRoomSearch(for: newQuery)
            }
        }.task {
            await vm.studyRoomSearch(for: query)
        }
    }
}

struct StudyRoomSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomSearchResultScreen(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: .constant("studyroom garching"))
    }
}

struct StudyRoomsService_Preview: StudyRoomsServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> StudyRoomApiRespose {
        return StudyRoomApiRespose.previewData
    }
}
