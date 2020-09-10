//
//  AppDelegate.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItemToProcess: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if ProcessInfo.processInfo.arguments.contains("-logout") {
            AuthenticationHandler().logout()
        }

        setupAppearance()
        FirebaseApp.configure()

        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let gradesShortcut = UIApplicationShortcutItem(type: "grades",
                                                       localizedTitle: "Grades",
                                                       localizedSubtitle: nil,
                                                       icon: UIApplicationShortcutIcon(systemImageName: "checkmark.shield"))

        let cafeteriaShortcut = UIApplicationShortcutItem(type: "cafeteria",
                                                          localizedTitle: "Cafeterias",
                                                          localizedSubtitle: nil,
                                                          icon: UIApplicationShortcutIcon(systemImageName: "house"))

        let studyRoomsShortcut = UIApplicationShortcutItem(type: "study_room",
                                                           localizedTitle: "Study Rooms",
                                                            localizedSubtitle: nil,
                                                            icon: UIApplicationShortcutIcon(systemImageName: "book"))

        let roomFinder = UIApplicationShortcutItem(type: "room_finder",
                                                   localizedTitle: "Room Finder",
                                                   localizedSubtitle: nil,
                                                   icon: UIApplicationShortcutIcon(type: .search))

        application.shortcutItems = [gradesShortcut, cafeteriaShortcut, studyRoomsShortcut, roomFinder]
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let shortcutItem = shortcutItemToProcess {

            let tabBarController = window?.rootViewController as? CampusTabBarController

            switch shortcutItem.type {
            case "grades": tabBarController?.selectedIndex = 2
            case "cafeteria": tabBarController?.selectedIndex = 3
            case "study_room": tabBarController?.selectedIndex = 4
            case "room_finder":
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let roomFinder = storyboard.instantiateViewController(identifier: "RoomFinderViewController") as! RoomFinderViewController
                let navigationController = UINavigationController(rootViewController: roomFinder)
                tabBarController?.show(navigationController, sender: nil)
            default: break
            }

            // Reset the shortcut item so it's never processed twice.
            shortcutItemToProcess = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Alternatively, a shortcut item may be passed in through this delegate method if the app was
        // still in memory when the Home screen quick action was used. Again, store it for processing.
        shortcutItemToProcess = shortcutItem
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = .tumBlue
        UITabBar.appearance().tintColor = .tumBlue
        UIButton.appearance().tintColor = .tumBlue        
    }

    // MARK: - Core Data stack

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
        let context = AppDelegate.persistentContainer.viewContext
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

    // MARK: - State restoration

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

