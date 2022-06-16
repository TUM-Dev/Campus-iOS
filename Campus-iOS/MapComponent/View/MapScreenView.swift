//
//  MapScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 05.06.22.
//

import SwiftUI

@MainActor
struct MapScreenView: View {
    @StateObject var vm: MapViewModel
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        // -> Here check the status of the fetched cafeterias
        switch vm.mode {
        case .cafeterias:
            Group {
                switch vm.cafeteriasState {
                case .success(_):
                    VStack {
                        MapView(vm: self.vm)
                        //Text("MapView")
                        //TestView(vm: self.vm)
                    }
                    .refreshable {
                        await vm.getCafeteria(forcedRefresh: true)
                    }
                case .loading, .na:
                    LoadingView(text: "Fetching Canteens")
                case .failed(let error):
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getCafeteria)
                }
            }
            .task {
                await vm.getCafeteria()
            }
            .alert("Error while fetching Cafeterias", isPresented: $vm.hasError, presenting: vm.cafeteriasState) {
                detail in
                Button("Retry") {
                    Task {
                        await vm.getCafeteria()
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: { detail in
                if case let .failed(error) = detail {
                    Text(error.localizedDescription)
                }
            }
        case .studyRooms:
            Group {
                switch vm.studyRoomsState {
                case .success(_):
                    VStack {
                        MapView(vm: self.vm)
                        //Text("MapView")
                        //TestView(vm: self.vm)
                    }
                    .refreshable {
                        await vm.getStudyRoomResponse(forcedRefresh: true)
                    }
                case .loading, .na:
                    LoadingView(text: "Fetching Study Rooms")
                case .failed(let error):
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getStudyRoomResponse)
                }
            }
            .task {
                await vm.getStudyRoomResponse()
            }
            .alert("Error while fetching Study Rooms", isPresented: $vm.hasError, presenting: vm.studyRoomsState) {
                detail in
                Button("Retry") {
                    Task {
                        await vm.getStudyRoomResponse()
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: { detail in
                if case let .failed(error) = detail {
                    Text(error.localizedDescription)
                }
            }
        }
    }
}
