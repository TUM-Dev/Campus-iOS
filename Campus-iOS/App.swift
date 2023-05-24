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
        }
    }
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                CalendarScreen(
                    model: model,
                    refresh: $model.isUserAuthenticated
                )
                .navigationTitle("Calendar")
            }
            .tag(4)
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
            }
            .tag(1)
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
                .tag(0)
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
            }
            .tag(2)
            .tabItem {
                Label("Grades", systemImage: "checkmark.shield").environment(\.symbolVariants, .none)
            }
            .if(UIDevice.current.userInterfaceIdiom == .pad, transformT: { view in
                view.navigationViewStyle(.stack)
            })
                
            NavigationView {
                MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
            }
            .tag(3)
            .tabItem {
                Label("Places", systemImage: "mappin.and.ellipse")
            }
            .navigationViewStyle(.stack)
        }
    }
}
