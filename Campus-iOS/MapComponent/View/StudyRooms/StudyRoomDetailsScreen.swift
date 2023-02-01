//
//  StudyRoomDetailsScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import SwiftUI

struct StudyRoomDetailsScreen: View {
    @StateObject var vm = StudyRoomViewModel()
    let room: StudyRoom
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let roomImageMapping):
                VStack {
                    StudyRoomDetailsView(studyRoom: self.room, roomImageMapping: roomImageMapping)          .refreshable {
                        await vm.getRoomImageMapping(for: room, forcedRefresh: true)
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching RoomImages")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: {forcedRefresh in await vm.getRoomImageMapping(for: self.room, forcedRefresh: forcedRefresh)}
                )
            }
        }.task {
            await vm.getRoomImageMapping(for: self.room)
        }.alert(
            "Error while fetching Room Images",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getRoomImageMapping(for: self.room, forcedRefresh: true)
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMCabeAPIError {
                        Text(apiError.errorDescription ?? "TUMCabeAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}

