//
//  Model.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import Foundation
import Combine
import SwiftUI

public class Model: ObservableObject {
    @Published var isLoginSheetPresented = true
    
    var anyCancellables: [AnyCancellable] = []
    
//    init() {
//        // later set initial values
//    }
    
    func loadAllModels() {
        // later load all the models
    }
}
