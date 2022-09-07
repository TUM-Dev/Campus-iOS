//
//  AzureMap.swift
//  HeatmapSwiftUI
//
//  Created by Kamber Vogli on 26.08.22.
//

import Foundation
import SwiftUI
import AzureMapsControl

struct AzureMapWrapper: UIViewControllerRepresentable {
  
  class Coordinator: NSObject {}
  
  func makeUIViewController(context: Context) -> AMViewController {
    let viewController = AMViewController()
    return viewController
  }

  func updateUIViewController(_ uiViewController: AMViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }
}
