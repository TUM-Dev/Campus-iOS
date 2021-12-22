//
//  Campus_iOSApp.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import SwiftUI
import MapKit

// TODO: to be removed
import CoreData

@main
struct CampusApp: App {
    @StateObject var environmentValues: CustomEnvironmentValues = CustomEnvironmentValues()
    
    let persistenceController = PersistenceController.shared
    @StateObject var model: Model = MockModel()
    @State var selectedTab = 0
    @State var splashScreenPresented = false
    @State private var showingAlert = false
    
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
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TUM_Campus_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = CampusApp.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
