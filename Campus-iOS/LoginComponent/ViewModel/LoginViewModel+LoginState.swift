//
//  LoginViewModel+LoginState.swift
//  Campus-iOS
//
//  Created by David Lin on 17.10.22.
//

import Foundation

extension LoginViewModel {
    enum LoginState {
        case notChecked
        case logInError
        case loggedIn
    }
}
