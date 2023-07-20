//
//  AuthenticationHandler.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/17/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit.UIDevice
import Alamofire
import SWXMLHash
import CoreData
import KeychainAccess
import FirebaseCrashlytics
#if !targetEnvironment(macCatalyst)
import FirebaseAnalytics
#endif

enum LoginError: LocalizedError {
    case missingToken
    case serverError(message: String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Missing token"
        case let .serverError(message):
            return message
        case .unknown:
            return "Unknown error"
        }
    }
}


class AuthenticationHandler {
    private static let keychain = Keychain(service: "de.tum.campusapp")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)

    private(set) var credentials: Credentials? {
        get {
            // Used for unit tests
            if let tumID = ProcessInfo.processInfo.environment["TUM_ID"], let token = ProcessInfo.processInfo.environment["TOKEN"] {
                return Credentials.tumID(tumID: tumID, token: token)
            } else if ProcessInfo.processInfo.arguments.contains("-skip-login") {
                return Credentials.noTumID
            }

            guard let data = Self.keychain[data: "credentials"] else { return nil }
            return try? PropertyListDecoder().decode(Credentials.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try! PropertyListEncoder().encode(newValue)
                Self.keychain[data: "credentials"] = data
            } else {
                Self.keychain[data: "credentials"] = nil
            }
        }
    }

    func createToken(tumID: String, completion: @escaping (Result<String,Error>) -> Void) async {
        do {
            let tokenName = "TCA - \(await UIDevice.current.name)"
            
            let token: Token = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName), forcedRefresh: true)
            print(token.value)
            self.credentials = Credentials.tumID(tumID: tumID, token: token.value)
            completion(.success(token.value))
        } catch {
            print(error)
            completion(.failure(LoginError.serverError(message: error.localizedDescription)))
        }
    }
    
    func confirmToken() async -> Result<Bool, Error> {
        guard let credentials else {
            return .failure(TUMOnlineAPIError.invalidToken)
        }
        
        switch credentials {
            case .noTumID:
                return .failure(LoginError.missingToken)
            case .tumID(tumID: _, token: let token), .tumIDAndKey(tumID: _, token: let token, key: _):
                do {
                    let confirmation: Confirmation = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.tokenConfirmation, token: token, forcedRefresh: true)

                    if confirmation.value {
                        return .success(true)
                    } else {
                        return .failure(TUMOnlineAPIError.tokenNotConfirmed)
                    }
                } catch {
                    print(error.localizedDescription)
                    return .failure(LoginError.serverError(message: error.localizedDescription))
                }
        }
    }

    func logout() {
        #if !targetEnvironment(macCatalyst)
        Analytics.logEvent("logout", parameters: nil)
        #endif
        // deletes authenticationHandler.keychain[data: "credentials"]
        credentials = nil
    }

    func skipLogin() {
        #if !targetEnvironment(macCatalyst)
        Analytics.logEvent("skip_login", parameters: nil)
        #endif
        credentials = .noTumID
    }
}

class AuthenticationHandler_Preview: AuthenticationHandler {
    override var credentials: Credentials? {
        return .tumID(tumID: "Preview_TUMID", token: "Preview_Token")
    }
}
