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

@main
struct CampusApp: App {
    @StateObject var model: Model = Model.shared
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let persistenceController = PersistenceController.shared
    @State var isLoginSheetPresented = false

    init() {
        #if !DEBUG
        FirebaseApp.configure()
        #endif
        UITabBar.appearance().isOpaque = true
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
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
                .onOpenURL { url in
                    guard url.scheme == "tum" else {
                        return
                    }
                    
                    switch(url.host()) {
                        case "places":
                            model.selectedTab = .places
                        case "calendar":
                            model.selectedTab = .calendar
                        case "lectures":
                            model.selectedTab = .lectures
                        default:
                            return
                    }
                }
        }
    }
    
    func tabViewComponent() -> some View {
        TabView(selection: $model.selectedTab) {
            NavigationView {
                CalendarContentView(
                    model: model,
                    refresh: $model.isUserAuthenticated
                )
                .navigationTitle("Calendar")
                .onAppear {
                    OpenCalendar().donate()
                }
            }
            .tag(NavigationTabs.calendar)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .navigationViewStyle(.stack)
            
            NavigationView {
                LecturesScreen(vm: LecturesViewModel(
                    model: model,
                    service: LecturesService()
                ), refresh: $model.isUserAuthenticated)
                    .navigationTitle("Lectures")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
                    .onAppear {
                        ShowLectures().donate()
                    }
            }
            .tag(NavigationTabs.lectures)
            .tabItem {
                Label("Lectures", systemImage: "studentdesk")
            }
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationView {
                    WidgetScreen(model: model)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                ProfileToolbar(model: model)
                            }
                        }
                }
                .navigationViewStyle(.stack)
                .tag(NavigationTabs.home)
                .tabItem {
                    Label("Home", systemImage: "rectangle.3.group").environment(\.symbolVariants, .none)
                }
            }
            
            NavigationView {
                GradesScreen(model: model, refresh: $model.isUserAuthenticated)
                    .navigationTitle("Grades")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
                    .onAppear {
                        ShowGrades().donate()
                    }
            }
            .tag(NavigationTabs.grades)
            .tabItem {
                Label("Grades", systemImage: "checkmark.shield").environment(\.symbolVariants, .none)
            }
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
                
            NavigationView {
                MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
            }
            .tag(NavigationTabs.places)
            .tabItem {
                Label("Places", systemImage: "mappin.and.ellipse")
            }
            .navigationViewStyle(.stack)
        }
    }
}
