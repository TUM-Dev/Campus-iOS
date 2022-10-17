//
//  LoginViewModel+TokenState.swift
//  Campus-iOS
//
//  Created by David Lin on 17.10.22.
//

import Foundation

extension LoginViewModel {
    enum TokenState {
        case notChecked
        case inactive
        case active
    }
}
