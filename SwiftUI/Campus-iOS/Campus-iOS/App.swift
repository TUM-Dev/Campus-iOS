//
//  Campus_iOSApp.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import SwiftUI

@main
struct CampusApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var model: Model = MockModel()
    @State var selectedTab = 0
    @State var splashScreenPresented = false

    var body: some Scene {
        WindowGroup {
            tabViewComponent()
            .fullScreenCover(isPresented: $model.isLoginSheetPresented) {
//                if splashScreenPresented {
//                    Spinner()
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("There is a problem with the connection"),
//                                  message: Text("Please restart the app"),
//                                  dismissButton: .default(Text("Got it!")))
//                        }
//                } else {
//                    LoginView(model: model)
//                        .onAppear {
//                            selectedTab = 2
//                            KeychainService.removeAuthorization()
//                        }
//                }
                
                
//                LoginView(model: model)
//               .onAppear {
//                   selectedTab = 2
//                   KeychainService.removeAuthorization()
//               }
            }
            .onAppear {
                checkAuthorized(count: 0)
                // remove loaded model
            }
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
                Text("Dummy Lectures View")
                // LecturesView(model: model)
            }
            .tag(1)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            
            NavigationView {
                Text("Dummy Grades View")
                // GradesView(model: model)
            }
            .tag(2)
            .tabItem {
                Label("Grades", systemImage: "checkmark.shield")
            }
            NavigationView {
                Text("Dummy Cafeterias View")
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
