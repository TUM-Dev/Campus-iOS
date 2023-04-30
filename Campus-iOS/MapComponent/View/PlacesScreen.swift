//
//  PlacesScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct PlacesScreen: View {
    
    @StateObject var vm: MapViewModel

    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        Group {
            switch vm.cafeteriasState {
            case .success(_):
                switch vm.studyRoomsState {
                case .success(_):
                    PlacesView(vm: self.vm)
                        .padding(.top, 60)
                    .refreshable {
                        await vm.getCafeteria(forcedRefresh: true)
                        await vm.getStudyRoomResponse(forcedRefresh: true)
                    }
                case .loading, .na:
                    ZStack {
                        VStack {
                            LoadingView(text: "Fetching Study Rooms", position: .middletop)
                        }
                    }
                case .failed(let error):
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: { _ in
                            await vm.getStudyRoomResponse()
                        })
                    .onAppear {
                        withAnimation(.easeIn) {
                            vm.panelPos = .top
                        }
                    }
                }
            case .loading, .na:
                ZStack {
                    VStack {
                        LoadingView(text: "Fetching Canteens", position: .middletop)
                    }
                }
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure:  { _ in
                        await vm.getCafeteria()
                    } )
            }
        }
        .task {
            await vm.getCafeteria()
            await vm.getStudyRoomResponse()
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
    }
}
