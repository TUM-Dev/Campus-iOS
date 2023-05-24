//
//  Model.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 01.12.21.
//

import Foundation
import Combine
import SwiftUI
#if !targetEnvironment(macCatalyst)
import FirebaseAnalytics
#endif

@MainActor
public class Model: ObservableObject {
    
    @Published var showProfile = false {
        didSet {
            if showProfile {
                NotificationCenter.default.post(name: Notification.Name.tcaSheetBecameActiveNotification, object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name.tcaSheetBecameInactiveNotification, object: nil)
            }
        }
    }
    
    @Published var isLoginSheetPresented = false {
        didSet {
            if isLoginSheetPresented {
                NotificationCenter.default.post(name: Notification.Name.tcaSheetBecameActiveNotification, object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name.tcaSheetBecameInactiveNotification, object: nil)
            }
        }
    }
    
    @Published var loginController = AuthenticationHandler()
    @Published var isUserAuthenticated = false
    
    var anyCancellables: [AnyCancellable] = []
    
    var token: String? {
        switch self.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            self.loginController.logout()
            self.isLoginSheetPresented = true
            self.isUserAuthenticated = false
        }
    }
}

public class Model_Preview: Model {
    override init() {
        super.init()
        loginController = AuthenticationHandler_Preview()
    }
}
