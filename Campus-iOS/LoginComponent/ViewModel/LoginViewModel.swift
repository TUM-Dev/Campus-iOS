//
//  LoginViewModifier.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import Foundation
import SwiftUI
#if !targetEnvironment(macCatalyst)
import FirebaseAnalytics
#endif
import Seeker

class LoginViewModel: ObservableObject {
    @Published var firstTextField = ""
    @Published var numbersTextField = ""
    @Published var secondTextField = ""
    @Published var isContinuePressed = false
    @Published var showLoginAlert = false
    @Published var showTokenAlert = false
    @Published var alertMessage = ""
    private static let hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private let logger = Seeker.logger
    private let metrics = Seeker.promMetrics
    weak var model: Model?
    var loginController = AuthenticationHandler()
    
    var isContinueEnabled: Bool {
        let firstTextFieldValid = self.firstTextField.allSatisfy({$0.isLetter}) && self.firstTextField.count == 2
        let numbersTextFieldValid = self.numbersTextField.count == 2
        let secondTextFieldValid = self.secondTextField.allSatisfy({$0.isLetter}) && self.secondTextField.count == 3
        
        return firstTextFieldValid && secondTextFieldValid && numbersTextFieldValid
    }
    
    private var tumID: String? {
        return "\(firstTextField)\(numbersTextField)\(secondTextField)"
    }
    
    init(model: Model?) {
        self.model = model
    }
    
    func loginWithContinue() {
        guard let tumID = tumID else {
            self.showLoginAlert = true
            return
        }
        loginController.createToken(tumID: tumID) { [weak self] result in
            switch result {
            case .success:
                self?.showLoginAlert = false
                self?.alertMessage = ""
                self?.isContinuePressed = true
            case let .failure(error):
                self?.showLoginAlert = true
                self?.alertMessage = error.localizedDescription
                self?.isContinuePressed = false
            }
        }
    }
    
    func loginWithContinueWithoutTumID() {
        loginController.skipLogin()
    }
    
    func checkAuthorizzation() {
        loginController.confirmToken() { [weak self] result in
            switch result {
            case .success:
                #if !targetEnvironment(macCatalyst)
                Analytics.logEvent("token_confirmed", parameters: nil)
                #endif
                self?.showTokenAlert = false
                self?.model?.isLoginSheetPresented = false
                self?.model?.isUserAuthenticated = true
                self?.model?.showProfile = false
                self?.model?.loadProfile()
                self?.logger.info("User successfully logged in.")
                Self.hapticFeedbackGenerator.notificationOccurred(.success)
            case let .failure(error):
                let counter = self?.metrics.createCounter(forType: Int.self, named: "failed_login_attempts")
                counter?.inc()
                self?.showTokenAlert = true
                self?.model?.isUserAuthenticated = false
                self?.alertMessage = error.localizedDescription
            }
        }
    }
}
