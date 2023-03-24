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
                VStack {
                    Spacer()
                    LoadingView(text: "Fetching RoomImages")
                    Spacer()
                }
            case .failed(let error):
                VStack {
                    Text("Error: \(error.localizedDescription)")
                    Button(action: {
                        Task {
                            await self.vm.getRoomImageMapping(for: room, forcedRefresh: true)
                        }
                    }) {
                        Text("Try Again".uppercased())
                            .lineLimit(1).font(.body)
                                .frame(width: 200, height: 48, alignment: .center)
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color(.tumBlue))
                    .cornerRadius(10)
                    .padding()
                }
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
    
    func printCell(key: String, value: String?) -> some View {
        if let val = value {
            return AnyView(HStack {
                Text(key)
                    .foregroundColor(Color(UIColor.darkGray))
                Spacer()
                Text(val).foregroundColor(.gray)
            })
        }
        
        return AnyView(EmptyView())
    }
}

