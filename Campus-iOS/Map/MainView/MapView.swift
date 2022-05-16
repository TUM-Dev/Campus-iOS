//
//  MapView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit

@MainActor
struct MapScreen: View {
    @StateObject var vm: MapViewModel
    
    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        // -> Here check the status of the fetched cafeterias
        Group {
            switch vm.state {
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
            print(vm.state)
            print(vm.$state)
        }
        .alert("Error while fetching Cafeterias", isPresented: $vm.hasError, presenting: vm.state) {
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

struct TestView: View {
    @StateObject var vm: MapViewModel
    
    var body: some View {
        Text("We have \(vm.cafeterias.count) cafeterias")
    }
}

struct MapView: View {
    @StateObject var vm: MapViewModel
    
    /// DEPRECATED: Should be accessed via the vm in the specific view (MapContent, Panel or Toolbar)
    @State var zoomOnUser: Bool = true
    @State var panelPosition: String = " "
    @State var canteens: [Cafeteria] = []
    @State var selectedCanteenName: String = " "
    @State var selectedAnnotationIndex: Int = 0
    @State var selectedCanteen: Cafeteria = Cafeteria(location: Location(latitude: 0, longitude: 0, address: " "), name: " ", id: " ", queueStatusApi: nil)
    /// DEPRECATED: Should be accessed via the vm in the specific view (MapContent, Panel or Toolbar
    
    var body: some View {
        ZStack {
            MapContent(
                vm: self.vm)
            Panel(vm: self.vm)
            Toolbar(zoomOnUser: $zoomOnUser, selectedCanteenName: $selectedCanteenName, cafeteria: $selectedCanteen)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Map")
        .navigationBarHidden(true)
    }
}

/*struct MapView_Previews: PreviewProvider {
 static var previews: some View {
 MapView(zoomOnUser: true,
 panelPosition: "down",
 canteens: [],
 selectedCanteenName: "",
 selectedAnnotationIndex: 0)
 }
 }*/
