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
import AzureMapsControl

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    if let azureToken = Bundle.main.infoDictionary?["Azure_Token"] as? String {
        // Azure Portal > Heatmap > Authentication > Primary key
        AzureMaps.configure(subscriptionKey: azureToken)
        AzureMaps.view = "Auto"
    }
    return true
  }
}

@main
struct CampusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    @StateObject var model: Model = Model()
    
    let persistenceController = PersistenceController.shared
    @State var selectedTab = 0
    
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
                .sheet(isPresented: $model.isLoginSheetPresented) {
                    NavigationView {
                        LoginView(model: model)
                        .onAppear {
                            selectedTab = 2
                        }
                    }
                    .navigationViewStyle(.stack)
                }
                .environmentObject(model)
        }
    }
    
    
    func tabViewComponent() -> some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                CalendarContentView(model: model)
                    .navigationTitle("Calendar")
            }
            .tag(0)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .navigationViewStyle(.stack)
            
            NavigationView {
                LecturesScreen(model: model)
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
            .navigationViewStyle(.stack)
            
            NavigationView {
                GradesScreen(model: model)
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
            .navigationViewStyle(.stack)

            NavigationView {
                MapScreenView(vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()))
            }
            .tag(3)
            .tabItem {
                Label("Places", systemImage: "mappin.and.ellipse")
            }
            .navigationViewStyle(.stack)
          
          NavigationView {
            AzureMapWrapper()
              .ignoresSafeArea()
          }
          .tag(4)
          .tabItem {
              Label("Heatmap", systemImage: "map")
          }
          .navigationViewStyle(.stack)
        }
    }
}
