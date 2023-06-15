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
    @State private var selectedTab: Tab = .home
    @State var isLoginSheetPresented = false
    
    enum Tab {
            case home
            case grades
            case lectures
            case calendar
            case maps
        }
    
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
                .tag(Tab.home)
                .tabItem {
                    if selectedTab == .home {
                        Label("Home", systemImage: "house")
                            .foregroundColor(.highlightText)
                    } else {
                        Label("Home", systemImage: "house").environment(\.symbolVariants, .none)
                    }
                }
                .toolbarBackground(Color.primaryBackground, for: .tabBar)
            }
            // MARK: - Grades Screen
            NavigationView {
                GradesScreen(model: model, refresh: $model.isUserAuthenticated)
                    .overlay(NavigationBarView(model: model, title: "Grades".localized))
            }
            .tag(Tab.grades)
            .tabItem {
                if selectedTab == .grades {
                    Label("Grades", systemImage: "checkmark.shield")
                } else {
                    Label("Grades", systemImage: "checkmark.shield").environment(\.symbolVariants, .none)
                }
                
            }
            .toolbarBackground(Color.secondaryBackground, for: .tabBar)
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
                // MARK: - Lecture Screen
                NavigationView {
                LecturesScreen(vm: LecturesViewModel(
                    model: model,
                    service: LecturesService()
                ), refresh: $model.isUserAuthenticated)
                .overlay(NavigationBarView(model: model, title: "Lectures".localized))
            }
            .tag(Tab.lectures)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            .toolbarBackground(Color.primaryBackground, for: .tabBar)
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
                .overlay(NavigationBarView(model: model, title: "Calendar".localized))
            }
            .tag(Tab.calendar)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .toolbarBackground(Color.primaryBackground, for: .tabBar)
            .navigationViewStyle(.stack)
            // MARK: - Places Screen
            NavigationView {
                PlacesScreen(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
                    .background(Color.primaryBackground)
                    .overlay(NavigationBarView(model: model, title: "Places".localized))
                //MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
            }
            .tag(Tab.maps)
            .tabItem {
                Label("Places", systemImage: "mappin.and.ellipse")
            }
            .toolbarBackground(Color.primaryBackground, for: .tabBar)
            .navigationViewStyle(.stack)
        }
        .accentColor(.highlightText)
    }
}
