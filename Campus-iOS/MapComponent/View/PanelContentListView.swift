//
//  PanelContentListView.swift
//  Campus-iOS
//
//  Created by David Lin on 18.06.22.
//

import SwiftUI

struct PanelContentListView: View {
    
    @ObservedObject var vm: MapViewModel
    @Binding var searchString: String
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    //let position = PanelPosition.bottom
    
    var body: some View {
        
        switch vm.mode {
        case .cafeterias:
            Group {
                switch vm.cafeteriasState {
                case .success(_):
                    VStack {
                        PanelContentCafeteriasListView(viewModel: vm, searchString: $searchString)
                    }
                    .refreshable {
                        await vm.getCafeteria(forcedRefresh: true)
                    }
                case .loading, .na:
                    ZStack {
                        Color.white
                        VStack {
                            LoadingView(text: "Fetching Canteens", position: .middletop)
                            Spacer().frame(width: screenWidth, height: screenHeight * (1 - 8.2/10))
                        }
                    }
                case .failed(let error):
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getCafeteria)
                    .onAppear {
                        withAnimation(.easeIn) {
                            vm.panelPosition = "pushTop"
                        }
                    }
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
                        PanelContentStudyGroupsListView(viewModel: vm, searchString: $searchString)
                    }
                    .refreshable {
                        await vm.getStudyRoomResponse(forcedRefresh: true)
                    }
                case .loading, .na:
                    ZStack {
                        Color.white
                        VStack {
                            LoadingView(text: "Fetching Study Rooms", position: .middletop)
                            Spacer().frame(width: screenWidth, height: screenHeight * (1 - 8.2/10))
                        }
                    }
                case .failed(let error):
                    FailedView(
                        errorDescription: error.localizedDescription,
                        retryClosure: vm.getStudyRoomResponse)
                    .onAppear {
                        withAnimation(.easeIn) {
                            vm.panelPosition = "pushTop"
                        }
                    }
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

struct PanelContentListView_Previews: PreviewProvider {
    static var previews: some View {
        PanelContentListView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true), searchString: .constant(""))
    }
}
