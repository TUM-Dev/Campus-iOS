//
//  Campus_iOSApp.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import SwiftUI
import MapKit
import KVKCalendar
import Firebase

@available(iOS 16.0, *)
@main
@MainActor
struct CampusApp: App {
    @StateObject var model: Model = Model()
    let persistenceController = PersistenceController.shared
    @State var selectedTab = 0
    @State var isLoginSheetPresented = false
    
    init() {
#if !DEBUG
        FirebaseApp.configure()
#endif
        UITabBar.appearance().isOpaque = true
        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            tabViewComponent()
                .sheet(isPresented: $isLoginSheetPresented) {
                    NavigationView {
                        LoginView(model: model)
                            .onAppear {
                                selectedTab = 0
                            }
                    }
                    .navigationViewStyle(.stack)
                }
                .onReceive(model.$isLoginSheetPresented, perform: { isLoginSheetPresented in
                    self.isLoginSheetPresented = isLoginSheetPresented
                })
                .environmentObject(model)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .task {
                    guard let credentials = model.loginController.credentials else {
                        model.isUserAuthenticated = false
                        model.isLoginSheetPresented = true
                        return
                    }
                    
                    switch credentials {
                        case .noTumID:
                            model.isUserAuthenticated = false
                            model.isLoginSheetPresented = false
                    case .tumID(tumID: _, token: _), .tumIDAndKey(tumID: _, token: _, key: _):
                            model.isUserAuthenticated = true
                            model.isLoginSheetPresented = false
                    }
                }
                .background(Color.primaryBackground)
        }
    }
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            // MARK: - Home Screen
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationView {
                    HomeScreen(model: model)
                        .overlay(NavigationBarView(model: model))
                }
                .navigationViewStyle(.stack)
                .tag(0)
                .tabItem {
                    if selectedTab == 0 {
                        Label("Home", systemImage: "house")
                    } else {
                        Label("Home", systemImage: "house").environment(\.symbolVariants, .none)
                    }
                }
            }
            // MARK: - Grades Screen
            NavigationView {
                GradesScreen(model: model, refresh: $model.isUserAuthenticated)
                    .overlay(NavigationBarView(model: model, title: "Grades"))
            }
            .tag(1)
            .tabItem {
                if selectedTab == 1 {
                    Label("Grades", systemImage: "checkmark.shield")
                } else {
                    Label("Grades", systemImage: "checkmark.shield").environment(\.symbolVariants, .none)
                }
                
            }
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
                // MARK: - Lecture Screen
                NavigationView {
                LecturesScreen(vm: LecturesViewModel(
                    model: model,
                    service: LecturesService()
                ), refresh: $model.isUserAuthenticated)
                .overlay(NavigationBarView(model: model, title: "Lectures"))
            }
            .tag(2)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
                // MARK: - Calendar Screen
                NavigationView {
                CalendarScreen(
                    model: model,
                    refresh: $model.isUserAuthenticated
                )
                .background(Color.primaryBackground)
                .overlay(NavigationBarView(model: model, title: "Calendar"))
            }
            .tag(3)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .navigationViewStyle(.stack)
            // MARK: - Places Screen
            NavigationView {
                PlacesScreen(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
                    .background(Color.primaryBackground)
                    .overlay(NavigationBarView(model: model, title: "Places"))
                //MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
            }
            .tag(4)
            .tabItem {
                Label("Places", systemImage: "mappin.and.ellipse")
            }
            .navigationViewStyle(.stack)
        }
    }
}
