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

@MainActor
class LoginViewModel: ObservableObject {
    @Published var firstTextField = ""
    @Published var numbersTextField = ""
    @Published var secondTextField = ""
    @Published var alertMessage = ""
    private static let hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var model: Model
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
    
    init(model: Model) {
        self.model = model
    }
    
    func loginWithContinue(callback: @escaping (Result<Bool,Error>) -> Void) async {
        guard let tumID = tumID else {
            callback(.failure(LoginError.serverError(message: "No TUM ID")))
            return
        }
        
        await loginController.createToken(tumID: tumID, completion: { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.alertMessage = ""
                }
                callback(.success(true))
            case let .failure(error):
                self.alertMessage = error.localizedDescription
                callback(.failure(error))
            }
        })
    }
    
    func loginWithContinueWithoutTumID() {
        loginController.skipLogin()
    }
    
    func checkAuthorization(callback: @escaping (Result<Bool,Error>) -> Void) async {
        await loginController.confirmToken { result in
            switch result {
            case .success:
                #if !targetEnvironment(macCatalyst)
                Analytics.logEvent("token_confirmed", parameters: nil)
                #endif
                //wself?.model?.isLoginSheetPresented = false
                DispatchQueue.main.async {
                    self.model.isUserAuthenticated = true
                    self.model.showProfile = false
                }
                
                callback(.success(true))
            case let .failure(error):
                self.model.isUserAuthenticated = false
                self.alertMessage = error.localizedDescription
                callback(.failure(error))
            }
        }
    }
}
