//
//  Campus_iOSApp.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import SwiftUI
import MapKit
import KVKCalendar

@main
struct CampusApp: App {
    @StateObject var environmentValues: Model = Model()
    @StateObject var model: Model = MockModel()
    
    let persistenceController = PersistenceController.shared
    @State var selectedTab = 0
    @State var splashScreenPresented = false
    @State private var showingAlert = false
    
    init() {
        UITabBar.appearance().isOpaque = true
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            tabViewComponent()
                .sheet(isPresented: $model.isLoginSheetPresented) {
                    if splashScreenPresented {
                        Spinner()
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("There is a problem with the connection"),
                                      message: Text("Please restart the app"),
                                      dismissButton: .default(Text("Got it!")))
                            }
                    } else {
                        NavigationView {
                            LoginView(model: model)
                            .onAppear {
                                selectedTab = 2
                            }
                        }
                    }
                }
                .environmentObject(environmentValues)
        }
    }
    
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                CalendarContentView()
                    .navigationTitle("Calendar")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            CalendarToolbar(viewModel: CalendarViewModel())
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
                // CalendarView(model: model)
            }
            .tag(0)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            NavigationView {
                LecturesScreen()
                    .navigationTitle("Lectures")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
            }
            .tag(1)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            
            NavigationView {
                GradesScreen(model: model)
                //GradesScreen()
                    .navigationTitle("Grades")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
            }
            .tag(2)
            .tabItem {
                Label("Grades", systemImage: "checkmark.shield")
            }
            NavigationView {
                MapView(zoomOnUser: true,
                        panelPosition: "down",
                        canteens: [],
                        selectedCanteenName: " ",
                        selectedAnnotationIndex: 0,
                        selectedCanteen: Cafeteria(location: Location(latitude: 0, longitude: 0, address: " "), name: " ", id: " ", queueStatusApi: nil))
            }
            .tag(3)
            .tabItem {
                Label("Cafeterias", systemImage: "house")
            }
            
            NavigationView {
                Text("Dummy StudyRooms View")
                // StudyRoomsView(model: model)
            }
            .tag(4)
            .tabItem {
                Label("Study Rooms", systemImage: "book")
            }
        }
    }
}
