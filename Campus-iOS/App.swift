//
//  Campus_iOSApp.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import SwiftUI
import MapKit
@main
struct CampusApp: App {
    @StateObject var environmentValues: CustomEnvironmentValues = CustomEnvironmentValues()
    
    let persistenceController = PersistenceController.shared
    @State var selectedTab = 0
    @State var splashScreenPresented = false
    @State var isLoginSheetPresented = false
    @State private var showingAlert = false
    
    var body: some Scene {
        WindowGroup {
            tabViewComponent()
                .sheet(isPresented: $isLoginSheetPresented) {
                    if splashScreenPresented {
                        Spinner()
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("There is a problem with the connection"),
                                      message: Text("Please restart the app"),
                                      dismissButton: .default(Text("Got it!")))
                            }
                    } else {
                        NavigationView {
                            LoginView()
                                .onAppear {
                                    selectedTab = 2
                                    // KeychainService.removeAuthorization()
                                }
                        }
                    }
                }
                .onAppear {
                    checkAuthorized(count: 0)
                    //UITabBar.appearance().isTranslucent = false
                    //UITabBar.appearance().isOpaque = true
                    //UITabBar.appearance().barTintColor = colorScheme == .dark ? UIColor.black : UIColor.white
                    // remove loaded model
                }
                .environmentObject(environmentValues)
        }
    }
    
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Text("Dummy Calendar View")
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
                            ProfileToolbar(profileModel: ProfileModel())
                        }
                    }
            }
            .tag(1)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            
            NavigationView {
                GradesScreen()
                    .navigationTitle("Grades")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(profileModel: ProfileModel())
                        }
                    }
            }
            .tag(2)
            .tabItem {
                Label("Grades", systemImage: "checkmark.shield")
            }
            NavigationView {
                MapView(zoomOnUser: true)
                //Text("Dummy Cafeterias View")
                // CafeteriasView(model: model)
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
    
    func checkAuthorized(count: Int) {
        // check if logged in
    }
}
