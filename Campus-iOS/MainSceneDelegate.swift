//
//  MainSceneDelegate.swift
//  Campus-iOS
//
//  Created by Moritz on 11.03.23.
//

import SwiftUI
import UIKit

final class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {
  @Environment(\.openURL) private var openURL: OpenURLAction
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let shortcutItem = connectionOptions.shortcutItem else {
      return
    }
    
    handleShortcutItem(shortcutItem)
  }
  
  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    handleShortcutItem(shortcutItem, completionHandler: completionHandler)
  }
  
  private func handleShortcutItem(
    _ shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping ((Bool) -> Void) = {_ in}
  ) {
      switch(shortcutItem.type) {
      case "de.tum.tca.shortcut.calendar":
          openURL(URL(string: "tum://calendar")!) { completed in
            completionHandler(completed)
          }
      case "de.tum.tca.shortcut.places":
          openURL(URL(string: "tum://places")!) { completed in
            completionHandler(completed)
          }
      case "de.tum.tca.shortcut.lectures":
          openURL(URL(string: "tum://lectures")!) { completed in
            completionHandler(completed)
          }
      default:
          completionHandler(false)
          return
    }
  }
}
