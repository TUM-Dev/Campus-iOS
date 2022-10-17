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
    
    @Published var loginController: AuthenticationHandler
    @Published var isUserAuthenticated = false
    @Published var profile: ProfileViewModel = ProfileViewModel()
    
    var anyCancellables: [AnyCancellable] = []
    
    init() {
        loginController = AuthenticationHandler()
        
        if loginController.credentials == Credentials.noTumID {
            isUserAuthenticated = false
        } else {
            loginController.confirmToken() { [weak self] result in
                switch result {
                case .success:
                    #if !targetEnvironment(macCatalyst)
                    Analytics.logEvent("token_confirmed", parameters: nil)
                    #endif
                    DispatchQueue.main.async {
                        self?.isLoginSheetPresented = false
                    }
                    self?.isUserAuthenticated = true
                    self?.loadProfile()
                case .failure(_):
                    self?.isUserAuthenticated = false
                    if let model = self {
                        if !model.showProfile {
                            DispatchQueue.main.async {
                                model.isLoginSheetPresented = true
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.isLoginSheetPresented = true
                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            self.loginController.logout()
            self.isLoginSheetPresented = self.showProfile ? false : true
            self.isUserAuthenticated = false
            self.unloadProfile()
        }
    }
    
    func unloadProfile() {
        DispatchQueue.main.async {
            self.profile = ProfileViewModel()
        }
    }
    
    func loadProfile() {
        self.profile = ProfileViewModel(model: self)
    }
}
