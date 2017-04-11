//
//  Grant.swift
//  Pods
//
//  Created by Mathias Quintero on 2/27/17.
//
//

import Foundation

enum Grant {
    case password(username: String, password: String, scope: String?)
    case refreshToken(token: String?)
    case authorizationCode(code: String)
    
    var dict: [String : String?] {
        switch self {
        case .password(let username, let password, let scope):
            return [
                "grant_type": "password",
                "username": username,
                "password": password,
                "scope": scope
            ]
        case .refreshToken(let token):
            return [
                "grant_type": "refresh_token",
                "refresh_token": token
            ]
        case .authorizationCode(let code):
            return [
                "grant_type": "authoriation_code",
                "code": code
            ]
        }
    }
}
