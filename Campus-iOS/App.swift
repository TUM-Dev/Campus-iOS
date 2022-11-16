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
    @StateObject var model: Model = Model()
    
    let persistenceController = PersistenceController.shared
    @State var selectedTab = 0
    @State var isLoginSheetPresented = false

    init() {
        FirebaseApp.configure()
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
                                selectedTab = 2
                            }
                    }
                    .navigationViewStyle(.stack)
                }
                .onReceive(model.$isLoginSheetPresented, perform: { isLoginSheetPresented in
                    self.isLoginSheetPresented = isLoginSheetPresented
                })
                .environmentObject(model)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                CalendarContentView(
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
            
            NavigationView {
                WidgetScreen(context: persistenceController.container.viewContext, model: model)
                    //.navigationTitle("My Widgets")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            ProfileToolbar(model: model)
                        }
                    }
            }
            .navigationViewStyle(.stack)
            .tag(0)
            .tabItem {
                Label("My Widgets", systemImage: "rectangle.3.group")
            }
            
            NavigationView {
                GradesScreen(context: persistenceController.container.viewContext, model: model, refresh: $model.isUserAuthenticated)
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
            
//            NavigationView {
//                GradesCDView(model: model)
//            }
//            .tag(5)
//            .tabItem {
//                Label("GradesCD", systemImage: "bolt.shield.fill")
//            }
//            .navigationViewStyle(.stack)
        }
    }
}
