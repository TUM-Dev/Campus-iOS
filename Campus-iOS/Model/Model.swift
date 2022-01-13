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
    @Published var showProfile = false
    @Published var isLoginSheetPresented = true
    @Published var loginController: AuthenticationHandler
    @Published var isUserAuthenticated = false
    
    var anyCancellables: [AnyCancellable] = []
    
    init() {
        loginController = AuthenticationHandler()
        
        if(loginController.credentials == Credentials.noTumID) {
            isUserAuthenticated = false
        } else {
            loginController.confirmToken() { [weak self] result in
                switch result {
                case .success:
                    #if !targetEnvironment(macCatalyst)
                    Analytics.logEvent("token_confirmed", parameters: nil)
                    #endif
                    self?.isLoginSheetPresented = false
                    self?.isUserAuthenticated = true
                case .failure(_):
                    self?.isLoginSheetPresented = true
                }
            }
        }
    }
    
    func logout() {
        loginController.logout()
        self.isLoginSheetPresented = true
        self.isUserAuthenticated = false
    }
    
    func loadAllModels() {
        // later load all the models
    }
}
